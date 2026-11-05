# API Catalog (OSINT)

Distilled from upstream: **cipher387/API-s-for-OSINT**
(https://github.com/cipher387/API-s-for-OSINT, license CC0 1.0 Universal - public domain).

- Refresh the catalog: `bash tools/sync-api-catalog.sh`
- This repo does NOT vendor the upstream README; this file is an extraction
  of API names + descriptions + price tiers per category.
- API keys are NOT stored in this repo - set them via env vars at runtime (see SECURITY.md).

## IOT/IP Search engines

- **Shodan** - Search engine for Internet connected host and devices `https://developer.shodan.io`
  - price: from $59/month
- **Netlas.io** - Search engine for Internet connected host and devices. Read more at [Netlas CookBook](https://github.com/netlas-io/netlas-cookbook) `https://docs.netlas.io/automation/`
  - price: Partly FREE
- **Fofa.info** - Search engine for Internet connected host and devices `https://en.fofa.info/api`
  - price: from $25/month
- **Censys.io** - Search engine for Internet connected host and devices `https://censys.io/api`
  - price: Partly FREE
- **Hunter.how** - Search engine for Internet connected host and devices `https://hunter.how/search-api`
  - price: Partly FREE
- **Fullhunt.io** - Search engine for Internet connected host and devices `https://api-docs.fullhunt.io/#introduction`
  - price: Partly FREE
- **IPQuery.io** - API for ip information such as ip risk, geolocation data, and asn details `https://ipquery.io`
  - price: FREE
- **IPLocate.io** - IP address threat data (proxy/vpn/Tor/relay detection API), hosting provider detection, geolocation lookup API (IP to city, country, region, postal code), IP to company and organization. `https://iplocate.io`
  - price: FREE
- **Hunt.io** - Complete Domain and IP Enrichment `https://hunt.io/products/cyber-threat-enrichment-api`
  - price: Free demo

## Universal OSINT APIs

- **Noimosiny** - Email, phone and username lookup. 250+ modules `https://noimosiny.com/`
  - price: PAID
- **Social Links** - Email info lookup, phone info lookup, individual and company profiling, social media tracking, dark web monitoring and more. Code example of using this API for face search in this [repo](https://github.com/SocialLinks-IO/sociallinks-api) `https://sociallinks.io/products/sl-api`
  - price: PAID. Price per request
- **Opsis** - Email and username lookup API. Searches 1,000+ modules and returns structured JSON with the profile details each source exposes, with streaming progress `https://useopsis.com/docs/api`
  - price: PAID. API access on the Pro plan, prepaid credits from $20 for 50

## Phone Number Lookup and Verification

- **Numverify** - Global Phone Number Validation & Lookup JSON API. Supports 232 countries. `https://numverify.com`
  - price: 250 requests FREE
- **Twillo** - Provides a way to retrieve additional information about a phone number `https://www.twilio.com/docs/lookup/api`
  - price: Free or $0.01 per request (for caller lookup)
- **Plivo** - Determine carrier, number type, format, and country for any phone number worldwide `https://www.plivo.com/lookup/`
  - price: from $0.04 per request
- **GetContact** - Find info about user by phone number `https://github.com/kovinevmv/getcontact`
  - price: from $6,89 in months/100 requests
- **Veriphone** - Phone number validation & carrier lookup `https://veriphone.io/`
  - price: 1000 requests/month FREE

## Address/ZIP codes lookup

- **Global Address** - Easily verify, check or lookup address `https://rapidapi.com/adminMelissa/api/global-address/`
  - price: FREE
- **US Street Address** - Validate and append data for any US postal address `https://smartystreets.com/docs/cloud/us-street-api`
  - price: FREE
- **Google Maps Geocoding API** - convert addresses (like "1600 Amphitheatre Parkway, Mountain View, CA") into geographic coordinates `https://developers.google.com/maps/documentation/geocoding/overview`
  - price: 0.005 USD per request
- **Postcoder** - Find adress by postcode `https://postcoder.com/address-lookup`
  - price: £130/5000 requests
- **Zipcodebase** - Lookup postal codes, calculate distances and much more `https://zipcodebase.com`
  - price: 5000 requests FREE
- **PostalCodes** - Search global postal codes, country exports, and address validation data `https://postalcodes.info/api`
  - price: FREE
- **Openweathermap geocoding API** - get geographical coordinates (lat, lon) by using name of the location (city name or area name) `https://openweathermap.org/api/geocoding-api`
  - price: 60 calls/minute 1,000,000 calls/month
- **DistanceMatrix** - Calculate, evaluate and plan your routes `https://distancematrix.ai/product`
  - price: $1.25-$2 per 1000 elements
- **Geotagging API** - Predict geolocations by texts `https://geotagging.ai/`
  - price: Freemium

## People and documents verification

- **Approuve.com** - Allows you to verify the identities of individuals, businesses, and connect to financial account data across Africa `https://appruve.co`
  - price: Paid
- **Onfido.com** - Onfido Document Verification lets your users scan a photo ID from any device, before checking it's genuine. Combined with Biometric Verification, it's a seamless way to anchor an account to the real identity of a customer. India `https://onfido.com`
  - price: Paid
- **Superpass.io** - Passport, Photo ID and Driver License Verification in India `https://surepass.io/passport-id-verification-api/`
  - price: Paid
- **National ID & Tax ID Validator API** - 222 ID types from 108 countries and territories. Get date of birth, gender, place of birth, taxpayer type and even the person’s initials `https://rapidapi.com/soxoj/api/national-id-tax-id-validator`
  - price: 500 requests free

## Business/Entity search

- **Open corporates** - Companies information `https://api.opencorporates.com`
  - price: Paid, price upon request
- **Linkedin company search API** - Find companies using keywords, industry, location, and other criteria `https://docs.microsoft.com/en-us/linkedin/marketing/integrations/community-management/organizations/company-search?context=linkedin%2Fcompliance%2Fcontext&tabs=http`
  - price: FREE
- **Mattermark** - Get companies and investor information `https://rapidapi.com/raygorodskij/api/Mattermark/`
  - price: free 14-day trial, from $49 per month

## Domain/DNS/IP lookup

- **API OSINT DS** - Collect info about IPv4/FQDN/URLs and file hashes in md5, sha1 or sha256 `https://github.com/davidonzo/apiosintDS`
  - price: FREE
- **InfoDB API** - The API returns the location of an IP address (country, region, city, zipcode, latitude, longitude) and the associated timezone in XML, JSON or plain text format `https://www.ipinfodb.com/api`
  - price: FREE
- **Domainsdb.info** - Registered Domain Names Search `https://domainsdb.info`
  - price: FREE
- **BGPView** - allowing consumers to view all sort of analytics data about the current state and structure of the internet `https://bgpview.docs.apiary.io/#`
  - price: FREE
- **DNSCheck** - monitor the status of both individual DNS records and groups of related DNS records `https://www.dnscheck.co/api`
  - price: up to 10 DNS records/FREE
- **Cloudflare Trace** - Get IP Address, Timestamp, User Agent, Country Code, IATA, HTTP Version, TLS/SSL Version & More `https://github.com/fawazahmed0/cloudflare-trace-api`
  - price: FREE
- **Host.io** - Get info about domain `https://host.io/`
  - price: FREE
- **Frostbyte DNS** - DNS record lookup and resolution — query A, AAAA, MX, TXT, NS, CNAME and other record types for any domain `https://agent-gateway-kappa.vercel.app`
  - price: 200 credits FREE
- **Kiprio Cert** - Inspect SSL/TLS certificates for any domain — expiry date, issuer, SANs, and full chain details `https://kiprio.com/v1/cert/`
  - price: FREE
- **DomainIntel** - Real-time domain intelligence: RDAP, DNS-over-HTTPS, Certificate Transparency and bulk lookups `https://domainintel.onrender.com`
  - price: FREE / Paid
- **cl0q** - Open search engine for domain research & OSINT — 38.5M domains scanned, 24.8M pages indexed, free API tier (30 req/min, 1,000/day) `https://cl0q.com`
  - price: FREE
- **NetAPI** - Domain lists and datasets per TLD (DNS, IP, hostname, emails, WHOIS dates), daily newly registered and deleted domains, domain and reverse IP lookup, free compromised domains / IPs feeds and a free Top 1M websites list `https://netapi.com/help/api/`
  - price: FREE (feeds, Top 1M, JSON stats) / Paid plans for downloads and lookups

## Mobile Apps Endpoints

- **BeVigil OSINT API** - provides access to millions of asset footprint data points including domain intel, cloud services, API information, and third party assets extracted from millions of mobile apps being continuously uploaded and scanned by users on bevigil.com `https://bevigil.com/osint-api`
  - price: 50 credits free/1000 credits/$50

## Scraping

- **Frostbyte Scraper** - Web scraping and content extraction API — returns page HTML, text, metadata, and structured data from any URL `https://agent-gateway-kappa.vercel.app`
  - price: 200 credits FREE
- **WebScraping.AI** - Web Scraping API with built-in proxies and JS rendering `https://webscraping.ai/`
  - price: FREE
- **ZenRows** - Web Scraping API that bypasses anti-bot solutions while offering JS rendering, and rotating proxies    apiKey    Yes    Unknown `https://www.zenrows.com/`
  - price: FREE
- **Arch Tools** - 61 AI tools API including web scraping, text extraction, code analysis, NLP, crypto data. REST + MCP protocol. x402 USDC micropayments `https://archtools.dev`
  - price: FREE tier (100 credits/mo)
- **TidyTools URL to Markdown** - Any public web page or PDF as clean Markdown or JSON with one GET request, no API key, rate limited (about 10 requests per minute) `https://tools.yukai.uk/free/url-to-markdown`
  - price: FREE
- **CurlShot** - Screenshot API: send a URL, HTML or Markdown and get a full-page PNG, JPEG, WebP, PDF or scrolling video, with device presets and optional cookie banner and ad hiding. Also has an MCP server `https://curlshot.com`
  - price: FREE tier (100 screenshots/mo)

## Whois

- **Whois freaks** - well-parsed and structured domain WHOIS data for all domain names, registrars, countries and TLDs since the birth of internet `https://whoisfreaks.com/`
  - price: $19/5000 requests
- **WhoisXMLApi** - gathers a variety of domain ownership and registration data points from a comprehensive WHOIS database `https://whois.whoisxmlapi.com`
  - price: 500 requests in month/FREE
- **IPtoWhois** - Get detailed info about a domain `https://www.ip2whois.com/developers-api`
  - price: 500 requests/month FREE
- **WhoisJsonApi** - Provides WHOIS data for all domain names, registrars, countries, and TLDs, covering the entire internet. `https://whoisjsonapi.com/`
  - price: 2 millions/requests for $50

## GEO IP

- **Ipstack** - Detect country, region, city and zip code `https://ipstack.com`
  - price: FREE
- **Ipgeolocation.io** - provides country, city, state, province, local currency, latitude and longitude, company detail, ISP lookup, language, zip code, country calling code, time zone, current time, sunset and sunrise time, moonset and moonrise `https://ipgeolocation.io`
  - price: 30 000 requests per month/FREE
- **IPInfoDB** - Free Geolocation tools and APIs for country, region, city and time zone lookup by IP address `https://ipinfodb.com/api`
  - price: FREE
- **IP API** - Free domain/IP geolocation info `https://ip-api.com/`
  - price: FREE
- **Frostbyte API** - IP geolocation with country, city, region, ISP, coordinates, and timezone. Part of a unified API gateway with 40+ OSINT-friendly tools including DNS lookup, web scraping, and screenshots. `https://agent-gateway-kappa.vercel.app`
  - price: 200 credits FREE

## Wi-fi lookup

- **Mylnikov API** - public API implementation of Wi-Fi Geo-Location database `https://www.mylnikov.org`
  - price: FREE
- **Wigle** - get location and other information by SSID `https://api.wigle.net/`
  - price: FREE

## Network

- **PeetingDB** - Database of networks,  and the go-to location for interconnection data `https://www.peeringdb.com/apidocs/`
  - price: FREE
- **PacketTotal** - .pcap files analyze `https://packettotal.com/api.html`
  - price: FREE

## Finance

- **Binlist.net** - get information about bank by BIN `https://binlist.net/`
  - price: FREE
- **FDIC Bank Data API** - institutions, locations and history events `https://banks.data.fdic.gov/docs/`
  - price: FREE
- **Amdoren** - Free currency API with over 150 currencies `https://www.amdoren.com/currency-api/`
  - price: FREE
- **VATComply.com** - Exchange rates, geolocation and VAT number validation `https://www.vatcomply.com/documentation`
  - price: FREE
- **Alpaca** - Realtime and historical market data on all US equities and ETFs `https://alpaca.markets/docs/api-documentation/api-v2/market-data/alpaca-data-api-v2/`
  - price: FREE
- **Swiftcodesapi** - Verifying the validity of a bank SWIFT code or IBAN account number `https://swiftcodesapi.com`
  - price: $39 per month/4000 swift lookups
- **IBANAPI** - Validate IBAN number and get bank account information from it `https://ibanapi.com`
  - price: Freemium/10$ Starter plan
- **Eulerpool** - Company profiles, executives, insider trades, ownership, market data `https://eulerpool.com/developers`
  - price: Freemium/100k requests per month free
- **SiftingIO** - Real-time and historical US stock, forex, commodity and crypto data over REST and WebSocket `https://sifting.io/docs`
  - price: Freemium; API key required; 10,000 REST calls/month per market on Free

## Email

- **EVA** - Measuring email deliverability & quality `https://eva.pingutil.com/`
  - price: FREE
- **Mailboxlayer** - Simple REST API measuring email deliverability & quality `https://mailboxlayer.com/`
  - price: 100 requests FREE, 5000 requests in month — $14.49
- **EmailCrawlr** - Get key information about company websites. Find all email addresses associated with a domain. Get social accounts associated with an email. Verify email address deliverability. `https://emailcrawlr.com/`
  - price: 200 requests FREE, 5000 requets — $40
- **Voila Norbert** - Find anyone's email address and ensure your emails reach real people `https://www.voilanorbert.com/api/`
  - price: from $49 in month
- **Kickbox** - Email verification API `https://open.kickbox.com/`
  - price: FREE
- **FachaAPI** - Allows checking if an email domain is a temporary email domain `https://api.facha.dev/`
  - price: FREE
- **Kiprio Disposable Email** - Check if an email domain is disposable or temporary, no auth required `https://kiprio.com/v1/disposable-email/`
  - price: FREE
- **Kiprio Email Validate** - Validate email addresses with MX record checks, disposable domain detection, and typo suggestions `https://kiprio.com/v1/email-validate/`
  - price: FREE
- **OSINT Industries** - A powerful OSINT (Open-Source Intelligence) platform designed for investigators, analysts, and organizations to uncover digital footprints and gather real-time intelligence. It enables users to search emails, phone numbers, and other selectors to reveal online presence, perform background checks, and conduct digital investigations with unmatched accuracy and immediate insights `https://www.osint.industries/`
  - price: Free for non-profits; pricing for others varies

## Names/Surnames

- **Genderize.io** - Instantly answers the question of how likely a certain name is to be male or female and shows the popularity of the name. `https://genderize.io`
  - price: 1000 names/day free
- **Agify.io** - Predicts the age of a person given their name `https://agify.io`
  - price: 1000 names/day free
- **Nataonalize.io** - Predicts the nationality of a person given their name `https://nationalize.io`
  - price: 1000 names/day free

## Pastebin/Leaks

- **XposedOrNot** - Free Data Breach API `https://xposedornot.com/api_doc`
  - price: FREE
- **HaveIBeenPwned** - allows the list of pwned accounts (email addresses and usernames) `https://haveibeenpwned.com/API/v3`
  - price: $3.50 per month
- **Psdmp.ws** - search in Pastebin `https://psbdmp.ws/api`
  - price: $9.95 per 10000 requests
- **LeakPeek** - searc in leaks databases `https://psbdmp.ws/api`
  - price: $9.99 per 4 weeks unlimited access
- **BreachDirectory.com** - search domain in data breaches databases `https://breachdirectory.com/api_documentation`
  - price: FREE
- **LeekLookup** - search domain, email_address, fullname, ip address, phone, password, username in leaks databases `https://leak-lookup.com/api`
  - price: 10 requests FREE
- **BreachDirectory.org** - search domain, email_address, fullname, ip address, phone, password, username in leaks databases (possible to view password hashes) `https://rapidapi.com/rohan-patra/api/breachdirectory/pricing`
  - price: 50 requests in month/FREE
- **Breach House** - Search ransomware leaks, stealer logs, traditional breaches and leads by company, domain or email `https://breach.house/docs`
  - price: Paid
- **Hudson Rock** - Search if a domain, email address, or username was compromised in global Infostealer malware campaigns `https://cavalier.hudsonrock.com/docs`
  - price: FREE
- **Have I Been Ransomed?** - Check if your email, phone or company has been leaked by ransomware gangs, stealers or traditional breaches `https://haveibeenransom.com/howapi`
  - price: Paid

## Archives

- **Wayback Machine API (Memento API, CDX Server API, Wayback Availability JSON API)** - Retrieve information about Wayback capture data `https://archive.org/help/wayback_api.php`
  - price: FREE
- **TROVE (Australian Web Archive) API** - Retrieve information about TROVE capture data `https://trove.nla.gov.au/about/create-something/using-api`
  - price: FREE
- **Archive-it API** - Retrieve information about archive-it capture data `https://support.archive-it.org/hc/en-us/articles/115001790023-Access-Archive-It-s-Wayback-index-with-the-CDX-C-API`
  - price: FREE
- **UK Web Archive API** - Retrieve information about UK Web Archive capture data `https://ukwa-manage.readthedocs.io/en/latest/#api-reference`
  - price: FREE
- **Arquivo.pt API** - Allows full-text search and access preserved web content and related metadata. It is also possible to search by URL, accessing all versions of preserved web content. API returns a JSON object. `https://github.com/arquivo/pwa-technologies/wiki/Arquivo.pt-API`
  - price: FREE
- **Library Of Congress archive API** - Provides structured data about Library of Congress collections `https://www.loc.gov/apis/`
  - price: FREE
- **BotsArchive** - JSON formatted details about Telegram Bots available in database `https://botsarchive.com/docs.html`
  - price: FREE

## Hashes decrypt/encrypt

- **MD5 Decrypt** - Search for decrypted hashes in the database `https://md5decrypt.net/en/Api/`
  - price: 1.99 EURO/day

## Crypto

- **BTC.com** - get information about addresses and transanctions `https://btc.com/btc/adapter?type=api-doc`
  - price: FREE
- **Blockchair** - Explore data stored on 17 blockchains (BTC, ETH, Cardano, Ripple etc) `https://blockchair.com`
  - price: $0.33 - $1 per 1000 calls
- **Bitcointabyse** - Lookup bitcoin addresses that have been linked to criminal activity `https://www.bitcoinabuse.com/api-docs`
  - price: FREE
- **Bitcoinwhoswho** - Scam reports on the Bitcoin Address `https://www.bitcoinwhoswho.com/api`
  - price: FREE
- **Etherscan** - Ethereum explorer API `https://etherscan.io/apis`
  - price: FREE
- **apilayer coinlayer** - Real-time Crypto Currency Exchange Rates `https://coinlayer.com`
  - price: FREE
- **BlockFacts** - Real-time crypto data from multiple exchanges via a single unified API, and much more `https://blockfacts.io/`
  - price: FREE
- **Brave NewCoin** - Real-time and historic crypto data from more than 200+ exchanges `https://bravenewcoin.com/developers`
  - price: FREE
- **WorldCoinIndex** - Cryptocurrencies Prices `https://www.worldcoinindex.com/apiservice`
  - price: FREE
- **WalletLabels** - Labels for 7,5 million Ethereum wallets `https://www.walletlabels.xyz/docs`
  - price: FREE

## Malware

- **VirusTotal** - files and urls analyze `https://developers.virustotal.com/reference`
  - price: Public API is FREE
- **AbuseLPDB** - IP/domain/URL reputation `https://docs.abuseipdb.com/#introduction`
  - price: FREE
- **AlienVault Open Threat Exchange (OTX)** - IP/domain/URL reputation `https://otx.alienvault.com/api`
  - price: FREE
- **Phisherman** - IP/domain/URL reputation `https://phisherman.gg`
  - price: FREE
- **URLScan.io** - Scan and Analyse URLs `https://urlscan.io/about-api/`
  - price: FREE
- **Web of Thrust** - IP/domain/URL reputation `https://support.mywot.com/hc/en-us/sections/360004477734-API-`
  - price: FREE
- **Threat Jammer** - IP/domain/URL reputation `https://threatjammer.com/docs/introduction-threat-jammer-user-api`
  - price: ???

## Face Search

- **Search4faces** - Detect and locate human faces within an image, and returns high-precision face bounding boxes. Face⁺⁺ also allows you to store metadata of each detected face for future use. `https://search4faces.com/api.html`
  - price: $21 per 1000 requests

## # Face Detection

- **Face++** - Search for people in social networks by facial image `https://www.faceplusplus.com/face-detection/`
  - price: from 0.03 per call
- **BetaFace** - Can scan uploaded image files or image URLs, find faces and analyze them. API also provides verification (faces comparison) and identification (faces search) services, as well able to maintain multiple user-defined recognition databases (namespaces) `https://www.betafaceapi.com/wpa/`
  - price: 50 image per day FREE/from 0.15 EUR per request

##  Reverse Image Search

- **Google Reverse images search API** - This is a simple API built using Node.js and Express.js that allows you to perform Google Reverse Image Search by providing an image URL. `https://github.com/SOME-1HING/google-reverse-image-api/`
  - price: FREE (UNOFFICIAL)
- **TinEyeAPI** - Verify images, Moderate user-generated content, Track images and brands, Check copyright compliance, Deploy fraud detection solutions, Identify stock photos, Confirm the uniqueness of an image `https://services.tineye.com/TinEyeAPI`
  - price: Start from $200/5000 searches
- **Bing Images Search API** - With Bing Image Search API v7, help users scour the web for images. Results include thumbnails, full image URLs, publishing website info, image metadata, and more. `https://www.microsoft.com/en-us/bing/apis/bing-image-search-api`
  - price: 1,000 requests free per month FREE
- **MRISA** - MRISA (Meta Reverse Image Search API) is a RESTful API which takes an image URL, does a reverse Google image search, and returns a JSON array with the search results `https://github.com/vivithemage/mrisa`
  - price: FREE? (no official)
- **PicImageSearch** - Aggregator for different Reverse Image Search API `https://github.com/kitUIN/PicImageSearch`
  - price: FREE? (no official)

## ## AI Geolocation

- **Geospy** - Detecting estimation location of uploaded photo `https://api.geospy.ai/`
  - price: Access by request
- **Picarta** - Detecting estimation location of uploaded photo `https://picarta.ai/api`
  - price: 100 request/day FREE
- **Oceanir** - Estimates photo locations from visual content without GPS metadata `https://docs.oceanir.ai/`
  - price: Paid credits; API access reviewed

## Social Media and Messengers

- **Twitch** -  `https://dev.twitch.tv/docs/v5/reference`
- **YouTube Data API** -  `https://developers.google.com/youtube/v3`
- **Arcmira** - Search indexed YouTube and podcast transcripts for quoted speech and return timestamped source links. `https://arcmira.com/docs`
  - price: Free tier and paid plans
- **Reddit** -  `https://www.reddit.com/dev/api/`
- **Vkontakte** -  `https://vk.com/dev/methods`
- **Twitter API** -  `https://developer.twitter.com/en`
- **Linkedin API** -  `https://docs.microsoft.com/en-us/linkedin/`
- **All Facebook and Instagram API** -  `https://developers.facebook.com/docs/`
- **Whatsapp Business API** -  `https://www.whatsapp.com/business/api`
- **Telegram and Telegram Bot API** -  `https://core.telegram.org`
- **Weibo API** -  `https://open.weibo.com/wiki/API文档/en`
- **XING** -  `https://dev.xing.com/partners/job_integration/api_docs`
- **Viber** -  `https://developers.viber.com/docs/api/rest-bot-api/`
- **Discord** -  `https://discord.com/developers/docs`
- **Odnoklassniki** -  `https://ok.ru/apiok`
- **Blogger** - The Blogger APIs allows client applications to view and update Blogger content `https://developers.google.com/blogger/`
  - price: FREE
- **Disqus** - Communicate with Disqus data `https://disqus.com/api/docs/auth/`
  - price: FREE
- **Foursquare** - Interact with Foursquare users and places (geolocation-based checkins, photos, tips, events, etc) `https://developer.foursquare.com/`
  - price: FREE
- **HackerNews** - Social news for CS and entrepreneurship `https://github.com/HackerNews/API`
  - price: FREE
- **Kakao** - Kakao Login, Share on KakaoTalk, Social Plugins and more `https://developers.kakao.com/`
  - price: FREE
- **Line** - Line Login, Share on Line, Social Plugins and more `https://developers.line.biz/`
  - price: FREE
- **TikTok** - Fetches user info and user's video posts on TikTok platform `https://developers.tiktok.com/doc/login-kit-web`
  - price: FREE
- **Tumblr** - Read and write Tumblr Data `https://www.tumblr.com/docs/en/api/v2`
  - price: FREE
- **TweetAPI** - Twitter data API: search, profiles, followers, lists, communities and Spaces, plus posting and DMs. No X developer account needed `https://tweetapi.com`
  - price: From $5 per 10,000 requests, 100 free
- **LurkAPI** - Public posts, profiles, comments, ads and video transcripts from 16 social platforms as JSON, plus an MCP server `https://lurkapi.com`
  - price: From $9 per 10,000 credits, 100 free
- **xdataapi.io** - Read-only public X (Twitter) data: profiles, tweets, threads, followers and search with x.com operators. MCP server and SDKs `https://xdataapi.io`
  - price: $0.06 to $0.125 per 1,000 items, 5,000 free credits

## UNOFFICIAL APIs

- **TikTok** - The Unofficial TikTok API Wrapper In Python `https://github.com/davidteather/TikTok-Api`
  - price: FREE
- **Google Trends** - Unofficial Google Trends API `https://github.com/suryasev/unofficial-google-trends-api`
  - price: FREE
- **YouTube Music** - Unofficial APi for YouTube Music `https://github.com/sigma67/ytmusicapi`
  - price: FREE
- **Google Maps** - Unofficial Google Places API `https://apify.com/compass/crawler-google-places`
  - price: FREE
- **Duolingo** - Duolingo unofficial API (can gather info about users) `https://github.com/KartikTalwar/Duolingo`
  - price: FREE
- **Steam.** - An unofficial object-oriented Python library for accessing the Steam Web API. `https://github.com/smiley/steamapi`
  - price: FREE
- **Instagram** - Instagram Private API `https://github.com/ping/instagram_private_api`
  - price: FREE
- **Discord** - JavaScript library for interacting with the Discord API `https://github.com/discordjs/discord.js`
  - price: FREE
- **Zhihu** - FREE Unofficial API for Zhihu `https://github.com/syaning/zhihu-api`
  - price: FREE
- **Quora** - Unofficial API for Quora `https://github.com/csu/quora-api`
  - price: FREE
- **DnsDumbster** - (Unofficial) Python API for DnsDumbster `https://github.com/PaulSec/API-dnsdumpster.com`
  - price: FREE
- **PornHub** - Unofficial API for PornHub in Python `https://github.com/sskender/pornhub-api`
  - price: FREE
- **Skype** - Unofficial Skype API for nodejs via 'Skype (HTTP)' protocol. `https://github.com/ShyykoSerhiy/skyweb`
  - price: FREE
- **Google Search** - Google Search unofficial API for Python with no external dependencies `https://github.com/aviaryan/python-gsearch`
  - price: FREE
- **Airbnb** - Python wrapper around the Airbnb API (unofficial) `https://github.com/nderkach/airbnb-python`
  - price: FREE
- **Medium** - Unofficial Medium Python Flask API and SDK `https://github.com/enginebai/PyMedium`
  - price: FREE
- **Facebook** - Powerful unofficial Facebook API `https://github.com/davidyen1124/Facebot`
  - price: FREE
- **Linkedin** - Unofficial Linkedin API for Python `https://github.com/tomquirk/linkedin-api`
  - price: FREE
- **Y2mate** - Unofficial Y2mate API for Python `https://github.com/Simatwa/y2mate-api`
  - price: FREE
- **Livescore** - Unofficial Livescore API for Python `https://github.com/Simatwa/livescore-api`
  - price: FREE

## Search Engines

- **Google Custom Search JSON API** - Search in Google `https://developers.google.com/custom-search/v1/overview`
  - price: 100 requests FREE
- **Memex Marginalia API** - Open source search engine. No ads, no AI. "Indexing the small, old and weird web"(c) Search blogs, forums, plain text sites and more. `https://memex.marginalia.nu/projects/edge/api.gmi`
  - price: FREE
- **Serpstack** - Google search results to JSON `https://serpstack.com/`
  - price: FREE
- **Serpapi** - Google, Baidu, Yandex, Yahoo, DuckDuckGo, Bint and many others search results `https://serpapi.com`
  - price: $50/5000 searches/month
- **Bing Web Search API** - Search in Bing (+instant answers and location) `https://www.microsoft.com/en-us/bing/apis/bing-web-search-api`
  - price: 1000 transactions per month FREE
- **WolframAlpha API** - Short answers, conversations, calculators and many more `https://products.wolframalpha.com/api/pricing/`
  - price: from $25 per 1000 queries
- **DuckDuckgo Instant Answers API** - An API for some of our Instant Answers, not for full search results. `https://duckduckgo.com/api`
  - price: FREE
- **SearchApi** - Google, Bing, Baidu, and many others search results `https://www.searchapi.io/`
  - price: $40/10000 searches/month
- **Memex Marginalia** - An API for new privacy search engine `https://memex.marginalia.nu/projects/edge/api.gmi`
  - price: FREE
- **Scraping Bee Google Search API** -  `https://www.scrapingbee.com/features/google/`
  - price: from $49/mo
- **ZenSerp** - Google, Yandex, Bing and YouTube search API `https://zenserp.com/`
  - price: 50 searches/months free
- **ScraperAPI** - Google Search API `https://www.scraperapi.com/`
  - price: from $49/mo
- **[SearchApi](https://www.searchapi.io/)** - 100 requests FREE `SearchApi - real-time JSON API to access 50+ SERP engines like Google, Bing, Baidu, YouTube, Amazon, and more.`

## News analyze

- **MediaStack** - News articles search results in JSON `https://mediastack.com/`
  - price: 500 requests/month FREE

## Darknet

- **Darksearch.io** - search by websites in .onion zone `https://darksearch.io/apidoc`
  - price: FREE
- **Onion Lookup** - onion-lookup is a service for checking the existence of Tor hidden services and retrieving their associated metadata. onion-lookup relies on an private AIL instance to obtain the metadata `https://onion.ail-project.org/`
  - price: FREE

## Torrents/file sharing

- **Jackett** - API for automate searching in different torrent trackers `https://github.com/Jackett/Jackett`
  - price: FREE
- **Torrents API PY** - Unofficial API for 1337x, Piratebay, Nyaasi, Torlock, Torrent Galaxy, Zooqle, Kickass, Bitsearch, MagnetDL,Libgen, YTS, Limetorrent, TorrentFunk, Glodls, Torre `[https://github.com/Jackett/Jackett](https://github.com/Ryuk-me/Torrent-Api-py)`
  - price: FREE
- **Torrent Search API** - API for Torrent Search Engine with Extratorrents, Piratebay, and ISOhunt `[https://github.com/Jackett/Jackett](https://rapidapi.com/theoneappkh/api/torrent-search/)`
  - price: 500 queries/day FREE
- **Torrent search api** - Yet another node torrent scraper (supports iptorrents, torrentleech, torrent9, torrentz2, 1337x, thepiratebay, Yggtorrent, TorrentProject, Eztv, Yts, LimeTorrents) `https://github.com/JimmyLaurent/torrent-search-api`
  - price: FREE
- **Torrentinim** - Very low memory-footprint, self hosted API-only torrent search engine. Sonarr + Radarr Compatible, native support for Linux, Mac and Windows. `https://github.com/sergiotapia/torrentinim`
  - price: FREE

## Vulnerabilities

- **National Vulnerability Database CVE Search API** - Get basic information about CVE and CVE history `https://nvd.nist.gov/developers/vulnerabilities`
  - price: FREE
- **OpenCVE API** - Get basic information about CVE `https://docs.opencve.io/api/cve/`
  - price: FREE
- **CVEDetails API** - Get basic information about CVE `https://www.cvedetails.com/documentation/apis`
  - price: partly FREE (?)
- **CVESearch API** - Get basic information about CVE `https://docs.cvesearch.com/`
  - price: by request
- **KEVin API** - API for accessing CISA's Known Exploited Vulnerabilities Catalog (KEV) and CVE Data `https://kevin.gtfkd.com/`
  - price: FREE
- **Vulners.com API** - Get basic information about CVE `https://vulners.com`
  - price: FREE for personal use
- **ICHI Internet Cyber Health Index** - HI provides a free, public API returning aggregated cybersecurity threat intelligence — critical threat alerts drawn from 20+ named, source-transparent public feeds (CISA KEV, CVE/NVD, Shodan, Censys, abuse.ch, US-CERT advisories, SANS ISC, and others). `https://ichi.global/api/alerts`
  - price: FREE

## Flights

- **Aviation Stack** - get information about flights, aircrafts and airlines `https://aviationstack.com`
  - price: FREE
- **OpenSky Network** - Free real-time ADS-B aviation data `https://opensky-network.org/apidoc/index.html`
  - price: FREE
- **AviationAPI** - FAA Aeronautical Charts and Publications, Airport Information, and Airport Weather `https://docs.aviationapi.com/`
  - price: FREE
- **FachaAPI** - Aircraft details and live positioning API `https://api.facha.dev`
  - price: FREE
- **Phantom Tide Restricted-Airspace Feed** - Replay-derived restricted-airspace crossing feed for aircraft observed in public airspace data `https://github.com/tg12/phantomtide?tab=readme-ov-file#public-restricted-airspace-feed`
  - price: FREE

## Webcams

- **Windy Webcams API** - Get a list of available webcams for a country, city or geographical coordinates `https://api.windy.com/webcams/docs`
  - price: FREE with limits or 9990 euro without limits

##  Regex

- **Autoregex** - Convert English phrase to regular expression `https://autoregex.notion.site/AutoRegex-API-Documentation-97256bad2c114a6db0c5822860214d3a`
  - price: from $3.49/month

## API testing tools

- **API Guessr (detect API by auth key or by token)** -  `https://api-guesser.netlify.app/`
- **REQBIN Online REST & SOAP API Testing Tool** -  `https://reqbin.com`
- **ExtendClass Online REST Client** -  `https://extendsclass.com/rest-client-online.html`
- **Codebeatify.org Online API Test** -  `https://codebeautify.org/api-test`
- **SyncWith Google Sheet add-on.  Link more than 1000 APIs with Spreadsheet** -  `https://workspace.google.com/u/0/marketplace/app/syncwith_crypto_binance_coingecko_airbox/449644239211?hl=ru&pann=sheets_addon_widget`
- **Talend API Tester Google Chrome Extension** -  `https://workspace.google.com/u/0/marketplace/app/syncwith_crypto_binance_coingecko_airbox/449644239211?hl=ru&pann=sheets_addon_widget`
- **Michael Bazzel APIs search tools** -  `https://inteltechniques.com/tools/API.html`

## Curl converters (tools that help to write code using API queries)

- **Convert curl commands to Python, JavaScript, PHP, R, Go, C#, Ruby, Rust, Elixir, Java, MATLAB, Dart, CFML, Ansible URI or JSON** -  `https://curlconverter.com`
- **Curl-to-PHP. Instantly convert curl commands to PHP code** -  `https://incarnate.github.io/curl-to-php/`
- **Curl to PHP online (Codebeatify)** -  `https://codebeautify.org/curl-to-php-online`
- **Curl to JavaScript fetch** -  `https://kigiri.github.io/fetch/`
- **Curl to JavaScript fetch (Scrapingbee)** -  `https://www.scrapingbee.com/curl-converter/javascript-fetch/`
- **Curl to C# converter** -  `https://curl.olsh.me`

## Create your own API

- **Sheety. Create API frome GOOGLE SHEET** -  `https://sheety.co/`
- **Postman. Platform for creating your own API** -  `https://www.postman.com`
- **Reetoo. Rest API Generator** -  `https://retool.com/api-generator/`
- **Beeceptor. Rest API mocking and intercepting in seconds (no coding).** -  `https://beeceptor.com`

## Distribute your own API

- **RapidAPI. Market your API for millions of developers** -  `https://rapidapi.com/solution/api-provider/`
- **Apilayer. API Marketplace** -  `https://apilayer.com`

## API Keys Info

- **Keyhacks** - Keyhacks is a repository which shows quick ways in which API keys leaked by a bug bounty program can be checked to see if they're valid. `https://github.com/streaak/keyhacks`
- **All about APIKey** - Detailed information about API key / OAuth token for different services (Description, Request, Response, Regex, Example) `https://github.com/daffainfo/all-about-apikey`
- **API Guessr** - Enter API Key and and find out which service they belong to `https://api-guesser.netlify.app/`

## API directories

- **APIDOG ApiHub** -  `https://apidog.com/apihub/`
- **Rapid APIs collection** -  `https://rapidapi.com/collections`
- **API Ninjas** -  `https://api-ninjas.com/api`
- **APIs Guru** -  `https://apis.guru/`
- **APIs List** -  `https://apislist.com/`
- **API Context Directory** -  `https://apicontext.com/api-directory/`
- **Any API** -  `https://any-api.com/`
- **Public APIs Github repo** -  `https://github.com/public-apis/public-apis`

## How to learn how to work with REST API?


## Contributing


## License

