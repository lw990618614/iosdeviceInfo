{
    "p2-launch-apple-store-path-patterns" =     (
        "^/([^/]+/)?xc/"
    );
    "p2-launch-appstore-host-patterns" =     (
        "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
        "^phobos[.]apple[.]com$",
        "^new[.]itunes[.]com$"
    );
    "p2-launch-appstore-path-patterns" =     (
        "[&?](mt=8|media=software)(&|$)",
        "^/webobjects/mzsoftwareupdate.woa/wa/(availablesoftwareupdates)",
        "^/webobjects/mzstore.woa/wa/(viewsoftware|pandastorefront|viewfeaturedsoftwarecategories|viewmultiplesystemoperator)",
        "^/webobjects/mzfinance.woa/wa/(com.apple.jingle.app.finance.directaction/)?(verifyaccountemail|associatevppuserwithitsaccount)",
        "^/([a-z][a-z]/)?(app|app-bundle|apps-store|apps-for-you|developer|story|mso|vpp-associate)(/|\\?|$)",
        "^/[a-z][a-z]/[^/]+[.]i$"
    );
    "p2-launch-ebookstore-host-patterns" =     (
        "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
        "^phobos[.]apple[.]com$",
        "^new[.]itunes[.]com$",
        "^books[.]apple[.]com$"
    );
    "p2-launch-ebookstore-path-patterns" =     (
        "[&?](mt=11|mt=13|mt=3)(&|$)",
        "^/webobjects/mzstore.woa/wa/(viewbook|viewGrouping)",
        "^/([a-z][a-z]/)?(audiobook|audiobooks|book|book-series|oprah|oprahs-book-club|redeem)(/|\\?|$)"
    );
    "p2-launch-host-suffix-whitelist" =     (
        "appsto.re",
        ".apple.com",
        "new.itunes.com"
    );
    "p2-launch-mobilestore-host-patterns" =     (
        "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
        "^phobos[.]apple[.]com$",
        "^new[.]itunes[.]com$"
    );
    "p2-launch-mobilestore-path-patterns" =     (
        "[&?](mt=[124569]|mt=13|app=itunes|app=music)(&|$)",
        "^/([a-z][a-z]/)?(activity|album|artist|audiobook|audiobooks|author|beats1|browse|carrier|category|celebrity-playlists|charts|collaboration|collection|collections|composer|connect|curator|customer-reviews|deeplink|director|episode|essential|essentials|family|faq|foryou|genre|imix|imixes|individual|learn-more|mix|movie|movie-collection|movie-rentals|movies|music|music-video|music-movie|mymusic|new|playlist|post|preorder|promotion|purchases|profile|review|reviews|show|store|studio|subscribe|tv-season|tv-show|tv-shows|video|itunes-u|institution|optintoconnections|optintoping|course|audit|complete-my-album|complete-my-season)(/|\\?|$)",
        "^/webobjects/mzstore.woa/wa/(storefront|viewtoptenslist|viewtopfifty|viewtop|viewactivity|viewaudiobook|viewcurator|viewgrouping|viewgenre|viewplaylist|viewplaylistspage|viewpost|viewroom|viewmultiroom|viewalbum|viewmix|storefronts|viewcontentsuserreviews|vieweula|viewtvshow|viewtvseason|viewmovie|viewvideo|footersections|librarylink|viewfeature|viewartist|viewcollaboration|viewcourse)",
        "^/webobjects/mzsearch.woa/wa/(search|advancedsearch)",
        "^/webobjects/mzstore.woa/wa/(viewradiomain)",
        "^/webobjects/mz(fast)?finance.woa/wa/(com.apple.jingle.app.finance.directaction/)?(redeemlandingpage|freeproductcodewizard|checkforpreorders|showdialogforredeem|checkforpurchasesauth|artistconnect|rejoinartistconnect|optintoconnections|rejoinoptintoconnections|optintoping|linkaccountpage|sagawelcome|priceincreaseconsentpage)",
        "^/webobjects/mzcontentlink.woa/wa/link(\\?|$)",
        "^/webobjects/mzstoreelements.woa/wa/",
        "^/webobjects/mzconnections.woa/wa/",
        "^/webobjects/mzuserpublishing.woa/wa/(manageartistalerts)",
        "^/webobjects/mzpersonalizer.woa/wa/(myalerts)"
    );
    "p2-url-resolution" =     (
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$",
                "^apps[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = WatchStore;
            "path-patterns" =             (
                "[&?](media=watch|app=watch)(&|$)"
            );
            "scheme-mapping" =             {
                http = "itms-watch";
                https = "itms-watchs";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$",
                "^apps[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = MessagesStore;
            "path-patterns" =             (
                "[&?](app=messages)(&|$)"
            );
            "scheme-mapping" =             {
                http = "itms-messages";
                https = "itms-messagess";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = TvAppViaQueryParam;
            "path-patterns" =             (
                "[&?](?:app=tv)(?:&|$)"
            );
            "scheme-mapping" =             {
                http = "com.apple.tv";
                https = "com.apple.tv";
            };
        },
                {
            "host-patterns" =             (
                "^apps[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "apps.apple.com"
            );
            "p2-url-section-name" = "apps.apple.com Media Domain";
            "path-patterns" =             (
                "^((?!age-verify).)*$"
            );
            "scheme-mapping" =             {
                http = "itms-apps";
                https = "itms-appss";
            };
        },
                {
            "host-patterns" =             (
                "^podcasts[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "podcasts.apple.com"
            );
            "p2-url-section-name" = "podcasts.apple.com Media Domain";
            "path-patterns" =             (
                ""
            );
            "scheme-mapping" =             {
                http = "itms-podcast";
                https = "itms-podcasts";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = Podcasts;
            "path-patterns" =             (
                "[&?]mt=2(&|$)",
                "^/webobjects/mzstore.woa/wa/(viewpodcast)",
                "^/([a-z][a-z]/)?(podcast|podcasts)(/|\\?|$)"
            );
            "scheme-mapping" =             {
                http = "itms-podcast";
                https = "itms-podcasts";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|search|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^appsto[.]re$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = iOSApps;
            "path-patterns" =             (
                "[&?](mt=8|media=software)(&|$)",
                "^/webobjects/mzsoftwareupdate.woa/wa/(availablesoftwareupdates)",
                "^/webobjects/mzstore.woa/wa/(viewsoftware|pandastorefront|viewfeaturedsoftwarecategories|viewmultiplesystemoperator)",
                "^/webobjects/mzfinance.woa/wa/(com.apple.jingle.app.finance.directaction/)?(verifyaccountemail|associatevppuserwithitsaccount)",
                "^/([a-z][a-z]/)?(app|app-bundle|apps-store|apps-for-you|developer|story|mso|vpp-associate)(/|\\?|$)",
                "^/[a-z][a-z]/[^/]+[.]i$"
            );
            "scheme-mapping" =             {
                http = "itms-apps";
                https = "itms-appss";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = OlderBooksRules;
            "path-patterns" =             (
                "[&?](mt=11|mt=13|mt=3)(&|$)",
                "^/webobjects/mzstore.woa/wa/(viewbook)",
                "^/([a-z][a-z]/)?(audiobook|audiobooks|book|book-series)(/|\\?|$)"
            );
            "scheme-mapping" =             {
                http = "itms-books";
                https = "itms-bookss";
            };
        },
                {
            "host-patterns" =             (
                "^((itunesu|(p[0-9]+-)?u)[.])?itunes[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = iTunesU;
            "path-patterns" =             (
                "[&?]mt=10(&|$)",
                "^/([a-z][a-z]/)?(course|learn-more|lecture|itunes-u|institution)(/|\\?|$)",
                "^/webobjects/lzdirectory.woa/wa/",
                "^/webobjects/dzr.woa/wa/(viewtagged|viewgenre)",
                "^/webobjects/mzstore.woa/wa/(viewcourse|viewlecture|viewitunesucollection|viewitunesuinstitution)",
                "^/audit/",
                "/audit[?$]",
                "^/enroll/",
                "^/enroll[?$]",
                "^/(courses|dashboard)(/|\\?|$|#)"
            );
            "scheme-mapping" =             {
                http = "itms-itunesu";
                https = "itms-itunesus";
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$",
                "^music[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = Music;
            "path-patterns" =             (
                "[&?](mt=[15]|mt=14|app=music)(&|$)",
                "^/([a-z][a-z]/)?(activity|album|artist|beats1|carrier|category|celebrity-playlists|charts|collaboration|collection|collections|composer|connect|curator|deeplink|episode|essential|essentials|family|faq|festival|foryou|imix|imixes|individual|learn-more|mix|music|music-video|music-movie|mymusic|new|playlist|post|preorder|promotion|profile|review|reviews|show|station|store|student|subscribe|video)(/|\\?|$)(?!.*[?&]app=itunes(&.*|$))(?!.*[?&](mt=(2|3|4|6|7|8|9|10|11|12|13|14))(&.*|$))(?!.*freeproductcodewizard)",
                "^/webobjects/mzstore.woa/wa/(storefront|viewtoptenslist|viewtopfifty|viewtop|viewplaylistspage|viewplaylist|viewactivity|viewbrand|viewroom|viewpost|viewmultiroom|viewalbum|viewmix|storefronts|viewcontentsuserreviews|viewvideo|footersections|librarylink|libraryadamidlink|viewfeature|viewartist|viewcollaboration)(/|\\?|$)(?!.*[?&]app=itunes(&.*|$))(?!.*[?&](mt=(2|3|4|6|7|8|9|10|11|12|13|14))(&.*|$))(?!.*freeproductcodewizard)",
                "^/webobjects/mzstore.woa/wa/(viewradiomain)",
                "^/webobjects/mzstoreelements2.woa/wa/"
            );
            "scheme-mapping" =             {
                http = music;
                https = musics;
            };
        },
                {
            "host-patterns" =             (
                "^((buy|my|search|c|itunesu|finance-app|geo)[.])?itunes[.]apple[.]com$",
                "^phobos[.]apple[.]com$",
                "^new[.]itunes[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = iTunesStore;
            "path-patterns" =             (
                "[&?](mt=[124569]|mt=13|app=itunes|app=music)(&|$)",
                "^/([a-z][a-z]/)?(album|artist|audiobook|audiobooks|author|browse|category|celebrity-playlists|charts|collaboration|collection|collections|composer|curator|customer-reviews|director|essential|essentials|family|faq|genre|imix|imixes|individual|learn-more|mix|movie|movie-collection|movie-rentals|movies|music|music-video|playlist|preorder|promotion|purchases|review|reviews|store|studio|tv-season|tv-show|tv-shows|video|itunes-u|institution|optintoconnections|optintoping|course|audit|complete-my-album|complete-my-season)(/|\\?|$)",
                "^/webobjects/mzstore.woa/wa/(storefront|viewtoptenslist|viewtopfifty|viewtop|viewaudiobook|viewgrouping|viewgenre|viewplaylistspage|viewroom|viewmultiroom|viewalbum|viewmix|storefronts|viewcontentsuserreviews|vieweula|viewtvshow|viewtvseason|viewmovie|viewvideo|footersections|librarylink|viewfeature|viewartist|viewcollaboration|viewcourse)",
                "^/webobjects/mzsearch.woa/wa/(search|advancedsearch)",
                "^/webobjects/mzstore.woa/wa/(viewradiomain)",
                "^/webobjects/mz(fast)?finance.woa/wa/(com.apple.jingle.app.finance.directaction/)?(redeemlandingpage|freeproductcodewizard|checkforpreorders|showdialogforredeem|checkforpurchasesauth|artistconnect|rejoinartistconnect|optintoconnections|rejoinoptintoconnections|optintoping|linkaccountpage|sagawelcome|priceincreaseconsentpage)",
                "^/webobjects/mzcontentlink.woa/wa/link(\\?|$)",
                "^/webobjects/mzstoreelements.woa/wa/",
                "^/webobjects/mzconnections.woa/wa/",
                "^/webobjects/mzuserpublishing.woa/wa/(manageartistalerts)",
                "^/webobjects/mzpersonalizer.woa/wa/(myalerts)"
            );
            "scheme-mapping" =             {
                http = itms;
                https = itmss;
            };
        },
                {
            "host-patterns" =             (
                "^music[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "music.apple.com"
            );
            "p2-url-section-name" = Music;
            "path-patterns" =             (
                "^((?!age-verify).)*$"
            );
            "scheme-mapping" =             {
                http = music;
                https = musics;
            };
        },
                {
            "host-patterns" =             (
                "^trailers[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = LegacyMovieTrailers;
            "path-patterns" =             (
                "^/trailers[?/]"
            );
            "scheme-mapping" =             {
                http = movietrailers;
                https = movietrailers;
            };
        },
                {
            "host-patterns" =             (
                "^(www|store|reserve|concierge|onetoone)[.]apple[.]com$"
            );
            "host-suffix-whitelist" =             (
                "appsto.re",
                ".apple.com",
                "new.itunes.com"
            );
            "p2-url-section-name" = LegacyAppleStore;
            "path-patterns" =             (
                "^/([^/]+/)?xc/"
            );
            "scheme-mapping" =             {
                http = applestore;
                https = "applestore-sec";
            };
        }
    );
    "vpp-licensing-invitation-url-pattern" = "^https://buy[.]itunes[.]apple[.]com/WebObjects/MZFinance.woa/wa/associateVPPUserWithITSAccount[?].*$";
}
