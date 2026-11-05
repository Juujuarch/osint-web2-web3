---
name: osint-geo
description: GEOINT and image OSINT skill - reverse image search, face search awareness, geolocation reasoning, and imagery verification. Includes matching logic for deciding whether an image was actually taken at a claimed location, with confidence tiers.
---
# OSINT GEOINT

## Agent instruction

1. EXIF/metadata first (if present = CONFIRMED signal)
2. Reverse image search across multiple engines
3. Geolocation reasoning: large objects -> small objects -> shadows/sun -> weather
4. Verify 2+ independent features in imagery; tier each feature
5. Output: estimated coordinates + comparison feature list + tier + confidence

## 1. Reverse image search

- Engines: Google Lens, Yandex Images (strongest for faces/local objects), TinEye, Bing Visual Search
- Variants: crop specific objects (signs, plates, buildings), resize/rotate, compare across engines
- Record: which engine matched, original source URL, publish date (may predate the post you saw)

## 2. Face search

- Commercial face-search services exist but legal/ethical limits are strict (biometric privacy: BIPA, GDPR)
- Default stance: do not face-search private individuals without a basis; for research, use public sources + manual verification
- If used: document the legal basis in the case file

## 3. Geolocation reasoning

Analysis order for a photo:
1. EXIF/metadata - coordinates, device, timestamp (often stripped; if present, hash it)
2. Large objects: building shapes, mountain ranges, coastlines, vegetation type
3. Small objects: signs (language/number format), utility poles, outlets, vehicles (plate format, steering side)
4. Shadows & sun: direction + length of shadows -> estimated time and sun position (suncalc)
5. Weather: conditions in the photo vs historical records

- Imagery: Mapillary (crowdsourced street-level), Sentinel/Landsat (land change), Google Earth historical
- Verification: find 2+ independent matching features before claiming a location

## MATCHING LOGIC - was this photo taken at location X?

| Signal | Tier | Note |
|---|---|---|
| GPS EXIF + consistent timestamp | CONFIRMED | device/timestamp can be spoofed, but strong by default |
| EXIF device + other photos from the same device at location X | STRONG | |
| Unique landmark + readable street name + plate format | STRONG | three independent small features |
| 2+ matching small features (sign language + steering side + outlet type) | STRONG | |
| Sun angle consistent with the claimed location and time | MEDIUM | supports or contradicts |
| Vegetation/climate match | SUPPORTING | |
| "Looks like it" / visual impression | WEAK | not a signal |

### Verdict rules

- confirmed: EXIF GPS (no manipulation indicators), or unique landmark + 2+ small features
- probable: 2+ independent small features match
- possible: 1 small feature or a generic landmark
- rejected: hard contradiction - sun angle in the wrong direction, plate format from another country, impossible vegetation for the climate, landmark actually elsewhere

### Contradictions to check

- Shadows vs claimed time (morning vs evening = opposite directions)
- Vehicle steering side vs country (left vs right)
- Plate format / sign language vs country
- Vegetation season vs photo date
- Weather in the photo vs historical records for that location

### Common traps

- Old photos re-posted with a new location claim (check reverse image for the original source + date)
- AI-generated / edited scenery
- Landmarks with "twins" in other countries (towers, statues, churches)
- Street View imagery that is stale vs current conditions

## 4. Verification discipline

- A location claim reaches high confidence only when a visual match can be reproduced by someone else
- Record: imagery URLs, estimated coordinates, comparison feature list, screenshots
- Photos can be moved or edited: the exercise is always "find evidence the photo was taken at location X", not "the photo resembles location X"