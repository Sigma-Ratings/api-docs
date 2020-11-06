---
title: Sigma API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='https://terminal.sigmaratings.com'>Sign Up for a Developer Key</a>

includes:
  - errors

search: true

code_clipboard: true
---

# Overview

The Sigma Ratings API is designed to give our programmatic access to our risk intelligence data so that it may be easily integrated into internal systems and databases.  

Our RESTful API returns a JSON dataset.  Sigma language bindings are in Shell. Code examples can be viewed in the dark area to the right.

# Authentication

The Sigma API uses Basic Authentication to access the API.

To obtain an API key please contact our client support team @ Support@sigmaratings.com

## Basic Authentication

To authorize your request you need to specify a base64 encoded value of the provided Sigma API key in an Authorization header. See [RFC2617](https://tools.ietf.org/html/rfc2617) for Basic Authentication reference. The following is an example of an encoded Authorization Header:

`Authorization: Basic ZGVtbzpwQDU1dzByZA==`

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: Basic ZGVtbzpwQDU1dzByZA==""
```


<aside class="notice">
You must replace <code>"ZGVtbzpwQDU1dzByZA=="</code> with your personal API key.
</aside>

<aside class="notice">
When using <code>curl</code> on Microsoft Windows you need to replace single-quotes in the examples with double-quotes. Alternatively, you can replace with <code>\"</code>.
</aside>

# Available Endpoints

<aside class="success">
All requests must specify an Authorization header.
</aside>

## API Account Status

```shell
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
{
  "msg": "ok",
  "token": "<API Key>",
  "request_limit": 10,
  "refresh_period": "monthly",
  "created": "2020-09-29T15:59:50.085109Z",
  "expires": null,
  "active": true,
  "permissions": {},
  "currentRequests": 0
}
```

This endpoint retrieves information about your API key.

### HTTP Request

`GET https://api.sigmaratings.com/v1/acccount_status`

## Risk Scoring

Sigma's Risk Scoring API is Sigma's primary API and brings together over 60 proprietary risk indicators (flags) to derive scores and provide access to key risk related data on 700 million entities worldwide. Calling the API with an entity name returns a Sigma Risk Score for the specified entity.


```shell
curl "https://api.sigmaratings.com/v1/risk?q=<entity name>"
  -H "Authorization: mZGVtbzpwQDU1dzByZA==" -d '{"filters":{"threshold":0.98, "category":"sigma"}}'
```

> The above command returns JSON structured like this:

```json 
{
	"indicator_summary": {
		"Address Risk": 1
	},
	"results": [{
		"name": "YARDPOINT SALES LLP",
		"type": "company",
		"strength": 0.9433497536945812,
		"source": "Corporate Registries",
		"indicators": [{
			"name": "Address Risk",
			"source_url": "",
			"description": "YARDPOINT SALES LLP is located at 175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW which appears to be associated with Alleged Shell Companies",
			"score": 70
		}],
		"locations": [{
			"country": "United Kingdom",
			"country_code": "GB",
			"type": "headquarters",
			"sources": [
				"https://opencorporates.com/companies/gb/OC374526"
			],
			"addresses": [{
				"address": "175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW"
			}]
		}]

	}]
  "score": {
    "level": "Severe"
    "rank": 73,
  },
  
}
```

### HTTP Request

`POST https://api.sigmaratings.com/v1/risk`

### URL Parameters

Parameter |  Description
--------- |  -----------
`q` | Entity search value

### Request body

Parameter | Description | Type   |
--------- | ----------- | ---------- |
`filters` | Filters to apply to search | Object |

_**filters**_ can be:

Filter | Description | Type | 
-------| ----------- | ----- | 
`threshold` | A decimal representation of match strength. See below for details on the `strength attribute` | float | 
`addresses` | Filters addresses from search results | Array |
`category` | Sigma category filter enables configuration of which integrations are used and how the data is returned. Custom categories can be created based on a specific use case upon request. Contact your Sigma customer success rep or Support@sigmaratings.com for details  | string |

### Response

_**Summary Data**_ 

Field | Description
--------- | ----------- | 
`indicator_summary` | Summary data that lists of all Risk Indicators found in the search and their corresponding counts. See Sigma Data Dictionary for detail on indicators. |
`score` | Sigma's overall risk score for the search results. Based on the number and severity of indicators found, as measure by the individual indicators scores. |

_**Results**_

The results section includes detail of all available entity matches. Each match can have one or more risk indicators and supporting data such as locations and business descriptions.

Field | Description
--------- | ----------- | 
`description` | Business description of entity that a match corresponds to. Descriptions can be stated business descriptions from external sources, or Sigma derived from trade activity
`indicators` | Summary of each Risk Indicator found in the search. See below for detail
`locations` | Country and address data found that relates to the matched entity. See below for detail
`name` | Entity name for the corresponding match. Name may be the primary entity name, an alias, or transliterated or translated name
`source` | Name of Sigma data integration the match is sourced from
`strength` | 0-1 score to measure how close the match name is to the entity name being searched as the `q` parameter. The threshold filter can be used to limit returned matches based on their strength
`type` | Denotes which Sigma Search option the match was returned from. Can be Company or People. Note Company search may return entities that are People, where they exist in unstructured or loosely structured sources 



_**Indicators**_ attribute detail for the `indicators` struct

Field | Description
--------- | ----------- | 
`description` | Description of the risk indicator and the entity name it relates to
`name` | Category name for the indicator. Name corresponds to the categories shown in the indicator_summary
`score` | 0-100 score to measure the relatiove risk severity of the indicator. eg. OFAC SDN sanctions are the most severe indicators, and score at 100 
`source_url` | Link to original source when available. When no source URL is found, additional context may be found via Sigma's Terminal


_**Locations**_ attribute detail for the `locations` struct

Field | Description
--------- | ----------- | 
`addresses` | Address string relating to an entity. Format varies by spurce & jurisdiction
`country` | Country name
`country_code` | 2 letter ISO-2 country code
`sources` | Source URL relating to a Location
`type` | Denotes how the location related to the company. For example, `trade` indicates the address was found in shipping records
