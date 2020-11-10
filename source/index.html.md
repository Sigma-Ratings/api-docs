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
	"summary": {
		  "score": 73.1,
      "level": "Severe",
      "detail": {
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
`threshold` | A decimal representation of match strength. See below for details on the `strength` attribute | float | 
`category` | Sigma category filter enables configuration of which integrations are used and how the data is returned | string |

### Response

The API response is structured as a `summary` section and `results` section. The summary data aggregates the results and can be used to build busines logic such as prioritizing investigations and segmenting searches. The results data enumerates all of the entity matches and their corresponding indicators and supporting data.

_**Summary Data**_ 

Field | Description
--------- | ----------- | 
`score` | Sigma's overall risk score for the search results. Based on the number and severity of indicators found, as measure by the individual indicators scores. Scored from zero to 100, with a higher score indicating higher chance of risk. |
`level` | The level indicates the risk category and can be used for high level categorization of searches. It is based on Sigma Score and whether data was identified.  (Read more on levels) |
`detail` | Summary data that lists of all Risk Indicators found in the search and their corresponding counts. See Sigma Data Dictionary for detail on indicators. |

The `level` attribute includes four options:

Level | Description
--------- | ----------- | 
`Severe` | Overall score above 70. At least one high risk AML typology found in search. | 
`Regular` | Overall score greater than zero and less than 70. At least one risk indicator found in search. |
`Low` | Overall score of zero with at least on description found. Sigma has found data that may indicate line of business. |
`No risk detected across Sigma data` | No indicators or descriptions found in search. Minimial data identified. May include location data via a corporate registry, but no line of business information available. |



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

Attribute detail for `indicators`:

Field | Description
--------- | ----------- | 
`description` | Description of the risk indicator and the entity name it relates to
`name` | Category name for the indicator. Name corresponds to the categories shown in the indicator_summary
`score` | 0-100 score to measure the relatiove risk severity of the indicator. eg. OFAC SDN sanctions are the most severe indicators, and score at 100 
`source_url` | Link to original source when available. When no source URL is found, additional context may be found via Sigma's Terminal

Attribute detail for `locations`:

Field | Description
--------- | ----------- | 
`addresses` | Address string relating to an entity. Format varies by spurce & jurisdiction
`country` | Country name
`country_code` | 2 letter ISO-2 country code
`source_urls` | One of more source URLs relating to a Location, if available
`type` | Denotes how the location related to the company. Includes options for `trade` indicates the address was found in shipping records


The `type` attribute currently includes two options:

Type | Description
--------- | ----------- | 
`Trade` | Indicates the address was found in shipping records. | 
`Operating` | Indicates the address was found in corporate records or third party company profiles. |
