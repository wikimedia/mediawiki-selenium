=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/LICENSE. No part of
mediawiki_selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/CREDITS.
=end

Then(/^page has no ResourceLoader errors$/) do
  result = browser.execute_script(<<-end)
return (function() {
    // Returns a string listing problem modules,
    // or empty string if all OK (or not a MediaWiki page).
    // MediaWiki registers many JS modules that are not loaded on average pages.
    var i, len, state,
        modules = mw.loader.getModuleNames(),
        error = [],
        missing = [],
        ret = '';
    if ( ( typeof mediaWiki === 'undefined' ) || !mediaWiki.loader ) {
        return ret;
    }

    for ( i = 0, len = modules.length; i < len; i++ ) {
        state = mw.loader.getState( modules[i] );
        if ( state === 'error' ) {
            error.push( modules[i] );
        }
        if ( state === 'missing' ) {
            missing.push( modules[i] );
        }
    }
    if ( error.length ) {
       ret += 'Error modules: ' + error.join( '; ') + '.';
    }
    if ( missing.length ) {
       ret += 'Missing modules: ' + missing.join( '; ') + '.';
    }
    return ret;
}) ();
  end

  expect(result).to eq('')
end
