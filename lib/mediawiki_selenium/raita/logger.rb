require 'cucumber/formatter/gherkin_formatter_adapter'
require 'net/http'

module MediawikiSelenium
  module Raita
    class Logger < Cucumber::Formatter::GherkinFormatterAdapter
      def initialize(_runtime, raita_options, options)
        super(Formatter.new, false, options)
        @db_url = URI.parse(raita_options[:url])
        @build = raita_options[:build].merge(result: { status: 'passed', duration: 0 })
      end

      # Log everything at once to Raita's Elasticsearch DB.
      #
      def after_features(*)
        build_id = create('build', @build)['_id']

        @gf.feature_hashes.each do |feature|
          amend_feature(feature)
          elements = feature.delete('elements')

          feature_id = create('feature', feature, build_id)['_id']
          bulk('feature-element', elements, feature_id)

          @build[:result][:status] = change_status(
            @build[:result][:status],
            feature['result']['status']
          )
          @build[:result][:duration] += feature['result']['duration']
        end

        update('build', build_id, @build)
      end

      private

      # Add status and duration at the feature and background/scenario level
      #
      # @param feature {Hash}
      #
      def amend_feature(feature)
        feature['result'] = { 'duration' => 0, 'status' => 'passed' }

        feature['elements'].each do |element|
          element['result'] = { 'duration' => 0, 'status' => 'passed' }

          element['steps'].each do |step|
            feature['result']['duration'] += step['result']['duration']
            element['result']['duration'] += step['result']['duration']

            element['result']['status'] = change_status(
              element['result']['status'],
              step['result']['status']
            )
          end

          feature['result']['status'] = change_status(
            feature['result']['status'],
            element['result']['status']
          )
        end
      end

      # Calculates a new status given the current parent status and the next
      # child status. A status can go from 'passed' to anything, 'skipped' to
      # 'failed'.
      #
      def change_status(cur, new)
        case cur.to_s
        when 'passed'
          new
        when 'skipped'
          new == 'failed' ? new : cur
        else
          cur
        end
      end

      def bulk(type, objects, parent = nil)
        data = objects.reduce('') do |d, obj|
          d << JSON.dump({ create: { _type: type, _parent: parent } }) + "\n"
          d << JSON.dump(obj) + "\n\n"
        end

        request(Net::HTTP::Post, ['_bulk'], data, parent: parent)
      end

      def create(type, object, parent = nil)
        request(Net::HTTP::Post, [type], object, parent: parent)
      end

      def request(klass, paths, data, query = {})
        query = query.reject { |_, v| v.nil? }

        uri = @db_url.clone
        uri.path = Pathname.new(uri.path).join(*paths.map(&:to_s)).to_s
        uri.query = query.map { |pair| pair.join('=') }.join('&')

        data = JSON.dump(data) unless data.is_a?(String)
        response = db.request(klass.new(uri), data)

        JSON.parse(response.body)
      end

      def update(type, id, object)
        request(Net::HTTP::Put, [type, id], object)
      end

      def db
        Net::HTTP.new(@db_url.host, @db_url.port)
      end
    end
  end
end
