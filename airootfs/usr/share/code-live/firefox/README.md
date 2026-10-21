# Bundled Firefox add-ons

Unmodified XPI files copied from the local Firefox profile. They contain add-on
code and assets, not the profile's storage, accounts or add-on settings.
Firefox performs its normal signature checks during installation.

| Add-on | Version | SHA-256 | Upstream |
| --- | --- | --- | --- |
| uBlock Origin | 1.75.0 | 5b74415860456370644bd80f16125e865b0e6c356bb5dfcfb84069967eaa5287 | https://addons.mozilla.org/firefox/addon/ublock-origin/ |
| Saffox Dark | 1.2 | 728d1049f5c12eca11c57bfeda25156df983f62d661327bcc3207e4f03b6b923 | https://addons.mozilla.org/firefox/downloads/file/4215480/saffox_dark-1.2.xpi |

`/etc/firefox/policies/policies.json` installs these files on first launch without
an internet download. Both add-ons can be disabled by the user. Standard add-on
updates and uBlock filter-list updates may use the network later.
The active-theme preference is set to Saffox Dark; first-run activation still
needs verification in the built ISO.

To update the bundled versions, replace the XPIs with trusted, Mozilla-signed
releases and update this table. No local uBlock custom rules, allowlists or
browser-profile databases are bundled.
