---
title: Sigma API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='https://terminal.sigmaratings.com'>Sign Up for a Developer Key</a>

includes:
  - errors
  - pagination

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

`Authorization: Basic c2lnbWFyYXRpbmdz`

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: Basic c2lnbWFyYXRpbmdz"
```


<aside class="notice">
You must replace <code>"c2lnbWFyYXRpbmdz"</code> with your personal API key.
</aside>

<aside class="notice">
When using <code>curl</code> on Microsoft Windows you need to replace single-quotes in the examples with double-quotes. Alternatively, you can replace with <code>\"</code>.
</aside>

# Available Endpoints

<aside class="success">
All requests must specify an Authorization header.
</aside>

## Account Status

```shell
curl "https://api.sigmaratings.com/v1/account_status"
  -H "Authorization: c2lnbWFyYXRpbmdz"
```

> The above command returns JSON structured like this:

```json
{
  "msg": "ok",
  "token": "sigmaratings",
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

## Audit

```shell
curl "https://api.sigmaratings.com/v1/audit/:id"
  -H "Authorization: c2lnbWFyYXRpbmdz"
```

> The above command returns JSON structured like this:

```json
{
  "id": "e723887d-4e3b-42ee-820c-339602aaa72c",
  "metadata": {
    "created": "2021-02-24T22:25:10.889959978Z"
  },
  "organization_id": "urn:sigma:organization:sigma-ratings",
  "request": {
    "filters": {
      "category": "sigma",
      "threshold": 0.95
    }
  },
  "response":  {
    "summary": {
      "score": 71.8,
      "level": "Elevated",
      "detail": {
        "Address": 1,
        "Registration Status": 1
      }
    },
    "results": [
      {
        "name": "YARDPOINT SALES LLP",
        "type": "company",
        "strength": 0.9433497536945812,
        "source": "Corporate Registries",
        "indicators": [
          {
            "category": "Registration Status",
            "description": "YARDPOINT SALES LLP has a company status of Unknown",
            "name": "Company status is Unknown",
            "score": 40,
            "source_url": "https://beta.companieshouse.gov.uk/company/OC374526"
          },
          {
            "category": "Address",
            "description": "Yardpoint Sales Llp is located at 175 DARKES LANE,SUITE B, 2ND FLOOR,HERTFORDSHIRE,EN6 1BW,POTTERS BAR, which appears to be associated with Alleged Shell Companies",
            "name": "Address  matches Alleged Shell Companies address",
            "score": 70,
            "source_url": ""
          }
        ],
        "locations": [
          {
            "country": "United Kingdom",
            "country_code": "GB",
            "type": "headquarters",
            "source_urls": [
              "https://opencorporates.com/companies/gb/OC374526"
            ],
            "addresses": [
              {
                "address": "175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW"
              }
            ]
          }
        ]
      }
    ]
  },
  "user_id": ""
}
```

This endpoint retrieves individual audit records. An audit record represents the request and response that was submitted using Sigma's API and it is used for traceability.

The following section describes in detail each field in the audit record:

Field | Description
--------- | ----------- | 
`audit_id` | Sigma's internal unique identifier assigned to a request.|
`user_id` | Represents the user that submitted the request. |
`organization_id` | Represents the organization for which the request was submitted. |
`request` | The request that was submitted as JSON payload. |
`response` | The response from the original request as JSON. |
`metadata` | Metadata from the original request. | 


Each request from the [risk](#risk-scoring) endpoint generates and `audit_id` field in its response, this id can be used to retrieve an audit record.

### HTTP Request

`GET https://api.sigmaratings.com/v1/audit/:id`

## Risk Scoring


```shell
curl "https://api.sigmaratings.com/v1/risk?q=YARDPOINT%20SALES%20LLP"
  -H "Authorization: c2lnbWFyYXRpbmdz" -d '{"filters":{"threshold":0.98, "mode":"sigma"}}'
```

> The above command returns JSON structured like this:

```json 
{
  "audit_id": "753a3714-2e3d-4a5b-b99e-5c802cb4ac16",
  "results": [
    {
      "description": null,
      "indicators": [
        {
          "category": "Address",
          "description": "175 Darkes Lane Suite B, 2nd Floor, Brosnan House, Potters Bar, Hertfordshire, England, EN6 1BW, UK, United Kingdom",
          "name": "Address  matches Alleged Shell Companies address",
          "score": 70,
          "source_urls": [],
          "urn": "urn:sigma:indicator:qRB69Boi1k-eNZYbpwMDwwKvU3sCeQvJV_7-29CS7zw="
        }
      ],
      "locations": [
        {
          "addresses": [
            "175 DARKES LANE, SUITE B, 2ND FLOOR, POTTERS BAR, HERTFORDSHIRE, EN6 1BW"
          ],
          "country": "United Kingdom",
          "country_code": "GB",
          "source_urls": null,
          "type": "Unspecified"
        }
      ],
      "match_name": "Yardpoint Sales Llp",
      "source": {
        "key": "sayari",
        "matchId": "Aphm-9QnsXBdPKg6Dx4O5Q",
        "name": "Sayari"
      },
      "strength": 1,
      "type": "company"
    }
  ],
  "summary": {
    "detail": {
      "Address": 1
    },
    "level": "Elevated",
    "score": 70.7
  }
}
```

Sigma's Risk Scoring powers compliant commercial and financial relationships globally.  It brings together over 60 proprietary financial crime-related risk indicators to derive entity risk scores from Sigma's database, which now includes 750 million companies, people and other legal entities. Calling the endpoint with an entity name returns a Sigma Risk Score for the specified entity.

A Sigma Risk Score for an entity is calculated using different available data points, these data points can be summarized as:

1. Determining the highest risk indicator for each category.
1. Aggregating the individual risk indicator scores for all categories.
1. Computing the final score by adding the highest risk indicator to the previously aggregated scores.

The final Sigma Risk Score range is from 0-100.

Individual Risk Indicator scores have a minimum possible and maximum possible range, these ranges are listed below:

Category | Minimum Score | Maximum Score
| --------- | :-----------: | :----------: |
Sanctions | 70 | 100
Transparency |	0 |	80
Enforcement Action |	40 |	70
Restricted Entity |	70 |	70
Address |	40 |	70
Registration Status |	0 |	70
Jurisdiction |	40 |	60
Adverse Media |	40 |	50
Global Trade |	20 |	50
PEP |	20 |	40
Line of Business |	20 |	40 
State Owned Entity |	20 |	20
Leadership |	10 |	30


A Sigma Risk Level is determined based on the Sigma Risk Score, the higher the risk, the more severe the assigned level will be. 

Risk Level for each Score range: 

| Level | Score |
| ----------- | ---------- |
| Elevated | 70 < 100 |
| Standard | 10 < 70 | 
| Neutral | 0 < 10|


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
`mode` | Sigma integrations filter enables configuration of which integrations are used and how the data is returned | string |
`countries` | A list of 2 letter [ISO-2 country code](https://www.iso.org/iso-3166-country-codes.html) to limit matches. Example: `["US","BR","BE","AU"]` | []string |
`indicators` | A string array of indicators to filter by | string

### Response

The API response is structured as: an `audit_id`, a `summary` section and `results` section. The `audit_id` is a uniquely identified id that can be used with the [audit endpoint](#audit) to retrieve a previously executed request. The `summary` data aggregates the results and can be used to build busines logic such as prioritizing investigations and segmenting searches. The `results` data enumerates all of the entity matches and their corresponding indicators and supporting data.

_**Summary Data**_ 

Field | Description
--------- | ----------- | 
`score` | Sigma's overall risk score for the search results. Based on the number and severity of risk `indicators` found, as measured by the individual indicator scores. Scored from zero to 100, with a higher score indicating a higher chance of risk. |
`level` | The level indicates the risk category and can be used for high level categorization of searches. It is based on Sigma Score and whether data was identified.  (Read more on levels) |
`detail` | Summary data that lists of all Risk Indicators found in the search and their corresponding counts. See Sigma Data Dictionary for detail on indicators. |

The `level` attribute includes four options:

Level | Description
--------- | ----------- | 
`Elevated` | Overall score above 70. At least one high-risk AML typology included in the risk indicators found in search. | 
`Standard` | Overall score greater than zero and less than 70. At least one risk indicator found in search. |
`Neutral` | Overall score of zero with at least on description found. Sigma has found data that may indicate line of business. |
`Unidentified` | No indicators or descriptions found in search. Minimal data identified across Sigma sources. Results may include location data via a corporate registry, but no line of business information available. |



_**Results**_

The results section includes detail of all available entity matches. Each match can have one or more risk indicators and supporting data such as locations and business descriptions.

Field | Description
--------- | ----------- | 
`description` | Business description of entity that a match corresponds to. Descriptions can be stated business descriptions from external sources, or Sigma derived from trade activity.
`indicators` | Summary of each Risk Indicator found in the search. See below for detail.
`locations` | Country and address data found that relates to the matched entity. See below for detail
`match_name` | Entity name for the corresponding match. Name may be the primary entity name, an alias, or transliterated or translated name.
`source` | Name of Sigma data integration the match is sourced from.
`strength` | 0-1 score to measure how close the match name is to the entity name being searched as the `q` parameter. The threshold filter can be used to limit returned matches based on their strength.
`type` | Denotes which Sigma Search option the match was returned from. Can be Company or People. Note Company search may return entities that are People, where they exist in unstructured or loosely structured sources.

Attribute detail for `indicators`:

Field | Description
--------- | ----------- | 
`category` | A grouping of similar risk types. Corresponds to the categories shown in the summary section.
`description` | Description of the risk indicator and the entity name it relates to.
`name` | Summarized description of the indicator. 
`score` | 0-100 score to measure the relatiove risk severity of the indicator. eg. OFAC SDN sanctions are the most severe indicators, and score at 100.
`source_urls` | Link to original source when available. When no source URL is found, additional context may be found via Sigma's Terminal.
`urn` | Unique identifier for indicator

Attribute detail for `locations`:

Field | Description
--------- | ----------- | 
`addresses` | Address string relating to an entity. Format varies by spurce & jurisdiction.
`country` | Country name.
`country_code` | 2 letter [ISO-2 country code](https://www.iso.org/iso-3166-country-codes.html).
`source_urls` | One of more source URLs relating to a Location, if available.
`type` | Denotes how the location related to the company. Includes options for `trade` indicates the address was found in shipping records.


The location `type` attribute currently includes two options:

Type | Description
--------- | ----------- | 
`Trade` | Indicates the address was found in shipping records. | 
`Operating` | Indicates the address was found in corporate records or third party company profiles. |
`Unspecified` | Indicates the address found but no available information on address type. |


## Bulk Risk Scoring
```shell
cat entities.json
{"id":"1", "name":"YARDPOINT SALES LLP"}
{"id":"2", "name":"Sigma Ratings"}

curl "https://api.sigmaratings.com/v1/bulk"
  -H "Authorization: mZGVtbzpwQDU1dzByZA==" -H "Content-Type: application/x-ndjson"
  -XPOST --data-binary "@entities.json"
```

> The above command returns JSON structured like this:

```json
{
  "id": "1e67becc-9405-4a3c-b4d0-78144bc8bba4",
  "message": "Request submitted",
  "created_at": "2016-11-28T00:00:00.0000000Z"
}
```

The Bulk Risk Scoring endpoint performs multiple requests of the [Risk Scoring](#risk-scoring) endpoint in a single request, by doing so, it reduces the overhead of calling the Risk Scoring endpoint multiple times, while providing a structured and summarized collection of the results. 

The Bulk Risk Scoring endpoint provides an `id`, which can be used to verify the status of the bulk request and retrieve the results of the request using the [Bulk Risk Scoring Status](#bulk-risk-scoring-status) endpoint.

### HTTP Request

`POST https://api.sigmaratings.com/v1/bulk`

<aside class="notice">This endpoint requires the Content-Type to be set to application/x-ndjson. The Content-Type requires a new line
to separate each entry, JSON entries must not include `\n`'s as delimiters. 
</aside>
<aside class="notice"> When providing a file input to the curl command, the --data-binary flag <i>must</i> be specified instead of plain -d. The -d flag does not preserve newlines. 
</aside>
For more information about the ndjson specification, please refer to: <a href='http://ndjson.org'>ndjson.org</a>.

### Query Parameters

Parameter |  Description | Type | Default
--------- |  ----------- | ------- | ----------
`threshold` | A decimal representation of match strength | float | 0.95
`mode` | Sigma integrations filter enables configuration of which integrations are used and how the data is returned | string | basic
`indicators` | A commma separated list of indicators to filter by | string | empty
`countries` | A comma separated list of countries to filter by | string | empty
`monitored` | A boolean value indicating whether entities should be monitored or not | boolean | false

### Available modes:

- `scan` Provides an essential view of sanctions, PEPs, and adverse news available.
- `basic` Scan, plus address, jurisdiction, association, and additional risks important in a more in depth review of risk .
- `sigma` The full Sigma view of risk, including everything in basic plus trade and state owned enterprise indicators.

### Available Indicators:

- `Address`
- `Adverse Media`
- `Enforcement Action`
- `Global Trade`
- `Jurisdiction`
- `Leadership`
- `Line of Business`
- `PEP`
- `Regisration Status`
- `Restricted Entity`
- `Sanctions`
- `State Owned Entity`
- `Transparency`  
- `Personnel`

### Request body
> The following is an example of the input file required for the bulk request endpoint:

```json
{"id":"1", "name": "Yardpoint Sales LLP"}
{"id":"2", "name": "Sigma Ratings"}
```

The contents of the request body is a sequence of newline delimited JSON requests.

## Risk Scoring Status
```shell
curl "https://api.sigmaratings.com/v1/bulk/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json
{
  "id": "c9ebf761-8851-4550-be7e-a14d07e0e57a",
  "status": "Completed",
  "presigned_url": "https://sigmaratings-uploads.s3.amazonaws.com/c9ebf761-8851-4550-be7e-a14d07e0e57a/c9ebf761-8851-4550-be7e-a14d07e0e57a.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQ7CCVENTOOV7CZ7M%2F20201210%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201210T213944Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=d1f8b6b2424be13692cff876775c27c25f698970fd4735ad7a1a2451593db23f",
  "created_at": "2016-11-28T00:00:00.0000000Z",
  "completed_at": "2016-11-29T00:00:00.0000000Z",
  "batches": {
    "total_num": 1,
    "total_num_completed": 1,
    "total_num_processing": 0,
    "total_num_remaining": 0
  },
   "settings": {
    "indicators": [
      "Enforcement Action",
      "Address",
      "Adverse Media",
    ],
    "mode": "basic",
    "threshold": 0.98
  }
}
```

The Bulk Risk Scoring status endpoint retrieves information about the bulk request. In addition to providing status of the bulk request, when the request completes, the status will display an additional field, a `presigned_url`. This url allows acccess to a compressed zip file containing the results of the bulk request. 

The compressed zip file is composed of three files:

- A Summary file, which aggregates all the data collected from each individual request. Summarizing the indicator count for each entity that was scored,
- A Details file, which contains details for each individual Risk Scoring request,
- and an Errors file, which is only be present if there were errors during the execution of the request. The errors file will contain an `id` and an error description, for each of the errors that were found.

> The following is an example of a summary file:

```json
{
  "id": "7db8e95b-bc8e-4f15-8404-96dd60a15a98",
  "completed_at": "2020-12-16T17:16:38.9416755Z",
  "created_at": "2020-12-16T17:16:48.9416755Z",
  "summary": [
    {
      "id": "1",
      "name": "YARDPOINT SALES LLP",
      "level": "Elevated",
      "score": 71.8,
      "sigma_url": "https://terminal.sigmaratings.com/open/search?query=YARDPOINT+SALES+LLP&threshold=0.95",
      "indicator_count": {
        "Address Risk": 1,
        "Registration Status": 1
      },
      "description_count": 3,
      "total_indicator_count": 2
    }
  ]
}
```

> The following is an example of a details file:

```json
{
  "id": "7db8e95b-bc8e-4f15-8404-96dd60a15a98",
  "created_at": "2020-12-16T17:16:38.9416755Z",
  "completed_at": "2020-12-16T17:16:48.9416755Z",
  "details": [
    {
      "id": "1",
      "name": "YARDPOINT SALES LLP",
      "level": "Elevated",
      "score": 71.8,
      "locations": [
        {
          "matches": [
            {
              "type": "Unspecified",
              "address": "175 DARKES LANE,SUITE B, 2ND FLOOR,HERTFORDSHIRE,EN6 1BW,POTTERS BAR",
              "country": "United Kingdom"
            }
          ],
          "match_name": "Yardpoint Sales Llp"
        },
        {
          "matches": [
            {
              "type": "Unspecified",
              "address": "175 DARKES LANE, SUITE B, 2ND FLOOR, POTTERS BAR, HERTFORDSHIRE, EN6 1BW",
              "country": "United Kingdom"
            }
          ],
          "match_name": "Yardpoint Sales Llp"
        },
        {
          "matches": [],
          "match_name": "Yardpoint Sales Llp"
        }
      ],
      "sigma_url": "https://terminal.sigmaratings.com/open/search?query=YARDPOINT+SALES+LLP&threshold=0.95",
      "indicators": {
        "Address": [
          {
            "score": 70,
            "match_name": "Yardpoint Sales Llp",
            "description": "Yardpoint Sales Llp is located at 175 DARKES LANE,SUITE B, 2ND FLOOR,HERTFORDSHIRE,EN6 1BW,POTTERS BAR, which appears to be associated with Alleged Shell Companies",
            "indicator_name": "Address matches Alleged Shell Companies address"
          },
          {
            "score": 70,
            "match_name": "Yardpoint Sales Llp",
            "description": "Yardpoint Sales Llp is located at 175 DARKES LANE, SUITE B, 2ND FLOOR, POTTERS BAR, HERTFORDSHIRE, EN6 1BW, which appears to be associated with Alleged Shell Companies",
            "indicator_name": "Address matches Alleged Shell Companies address"
          }
        ],
        "Registration Status": [
          {
            "score": 40,
            "match_name": "Yardpoint Sales Llp",
            "source_url": "https://beta.companieshouse.gov.uk/company/OC374526",
            "description": "YARDPOINT SALES LLP has a company status of Unknown",
            "indicator_name":	"Company status is Unknown"
          }
        ]
      },
      "indicator_summary": {
        "Address": 2,
        "Registration Status": 1
      }
    }
  ]
}
```

> The following is an example of an errors file:

```json
{
  "id": "7db8e95b-bc8e-4f15-8404-96dd60a15a98",
  "errors": [
    {
      "id": "1",
      "error": "Invalid request specified"
    }
  ]
}
```

> To help cross reference the errors, the `id` field in the error object, will correspond to the original `id` of the entity in the payload of the input request. e.g. `id` 1 in the errors file, represents Yardpoint Sales LLP in the original input request.

The name of the zip file will be in the form of: `<id>.zip` where the `id` corresponds to the bulk request created.

### HTTP Request

`GET https://api.sigmaratings.com/v1/bulk/:id`

### Response details

Field |  Description 
--------- |  -----------
`id` | A UUID to reference the request 
`status` | [Status](#status) of request. 
`presigned_url` | URL to download request submitted. A presigned url is a URL with a temporary access to the download location. This field is only present when the request is completed. 
`created_at` | Date when request was created.
`completed_at` | Date when request was completed.
`batches` | Status of request indicating processing status.
`settings` | Indicates the settings specified in the original request.

### Status

Name | Description
-----| -------------
`Submitted` | Request was submitted.
`Processing` | Bulk Request has begun processing.
`Uploading` | Bulk Request has been processed and is being uploaded.
`Completed` | Request was completed successfully.
`Completed With Errors` | Request was completed and there are errors in the request. An errors.json file will be present.

## Bulk Monitoring

Monitoring provides the ability to continuously monitor a group of related entities that are grouped by a bulk id. To start monitoring a group of related entities use the 
[bulk endpoint](#bulk-risk-scoring) and specify `true` on the `monitored` query parameter of the [bulk endpoint](#bulk-risk-scoring). Updates to the entities are calculated periodically and can be [retrieved individually](#monitor-entity-updates) or by [bulk id](#monitor-bulk-updates).

The monitor bulk endpoint retrieves all the entities that are monitored for the specified bulk id. See [pagination](#pagination) section for reference.

```shell
curl "https://api.sigmaratings.com/v1/monitor/bulk/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json

  {
  "data": [
   {
     "created_at": "2020-12-16T17:16:38.9416755Z",
     "monitored": true,
     "name": "YARDPOINT SALES LLP",
     "task_id": "424ff463-fd9b-4df8-99d8-f5ce2146502e",
     "threshold": 0.98,
     "updated_at": "2020-12-16T17:16:48.9416755Z",
     "urn": "urn:sigma:entity:9699f250-65e8-42be-9a92-c5bbf7cf82af"
   }
    
  ],
  "next": 1,
  "previous": null,
  "total": 1
}
```

### HTTP Request

`GET https://api.sigmaratings.com/v1/monitor/bulk/:id`

### Response details

Field |  Description 
--------- |  -----------
`created_at` | Timestamp of when the entity was first created.
`monitored` | Indicates whether entity is monitored or not.
`name` | Name of entity.
`bulk_id` | Unique identifier of bulk request.
`threshold` | Threshold that was used on initial bulk upload.
`updated_at` | Date when entity was last updated.
`id` | Unique identifier of entity.


## Entity Monitoring

Entity details provides the latest risk score calculated for the individual entity

```shell
curl "https://api.sigmaratings.com/v1/monitor/entity/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json

  {
  "monitored": true,
  "name": "YARDPOINT SALES LLP",
  "risk": {
    "summary": {
      "score": 71.8,
      "level": "Severe",
      "detail": {
        "Address": 1,
        "Registration Status": 1
      }
    },
   "results": [
      {
        "name": "YARDPOINT SALES LLP",
        "type": "company",
        "strength": 0.9433497536945812,
        "source": "Corporate Registries",
        "indicators": [
          {
            "category": "Registration Status",
            "description": "YARDPOINT SALES LLP has a company status of Unknown",
            "name": "Company status is Unknown",
            "score": 40,
            "source_url": "https://beta.companieshouse.gov.uk/company/OC374526"
          },
          {
            "category": "Address",
            "description": "Yardpoint Sales Llp is located at 175 DARKES LANE,SUITE B, 2ND FLOOR,HERTFORDSHIRE,EN6 1BW,POTTERS BAR, which appears to be associated with Alleged Shell Companies",
            "name": "Address  matches Alleged Shell Companies address",
            "score": 70,
            "source_url": ""
          }
        ],
        "locations": [
          {
            "country": "United Kingdom",
            "country_code": "GB",
            "type": "headquarters",
            "source_urls": [
              "https://opencorporates.com/companies/gb/OC374526"
            ],
            "addresses": [
              {
                "address": "175 Darkes Lane Suite B, 2nd Floor, Potters Bar, Hertfordshire, EN6 1BW"
              }
            ]
          }
        ]
      }
    ]
  },
  "id":"urn:sigma:entity:9699f250-65e8-42be-9a92-c5bbf7cf82af"
}
```

### HTTP Request

`GET https://api.sigmaratings.com/v1/monitor/entity/:id`

### Response details

Field |  Description 
--------- |  -----------
`id` | Unique resource identifier of entity
`monitored` | Indicates whether the entity is being monitored or not.
`name` | Entity name
`risk` | See detailed description of results object below.

_**Results**_

The results section includes detail of all available entity matches. Each match can have one or more risk indicators and supporting data such as locations and business descriptions.

Field | Description
--------- | ----------- | 
`description` | Business description of entity that a match corresponds to. Descriptions can be stated business descriptions from external sources, or Sigma derived from trade activity.
`indicators` | Summary of each Risk Indicator found in the search. See below for detail.
`locations` | Country and address data found that relates to the matched entity. See below for detail
`match_name` | Entity name for the corresponding match. Name may be the primary entity name, an alias, or transliterated or translated name.
`source` | Name of Sigma data integration the match is sourced from.
`strength` | 0-1 score to measure how close the match name is to the entity name being searched as the `q` parameter. The threshold filter can be used to limit returned matches based on their strength.
`type` | Denotes which Sigma Search option the match was returned from. Can be Company or People. Note Company search may return entities that are People, where they exist in unstructured or loosely structured sources.

Attribute detail for `indicators`:

Field | Description
--------- | ----------- | 
`category` | A grouping of similar risk types. Corresponds to the categories shown in the summary section.
`description` | Description of the risk indicator and the entity name it relates to.
`name` | Summarized description of the indicator. 
`score` | 0-100 score to measure the relatiove risk severity of the indicator. eg. OFAC SDN sanctions are the most severe indicators, and score at 100.
`source_urls` | Link to original source when available. When no source URL is found, additional context may be found via Sigma's Terminal.

Attribute detail for `locations`:

Field | Description
--------- | ----------- | 
`addresses` | Address string relating to an entity. Format varies by spurce & jurisdiction.
`country` | Country name.
`country_code` | 2 letter [ISO-2 country code](https://www.iso.org/iso-3166-country-codes.html).
`source_urls` | One of more source URLs relating to a Location, if available.
`type` | Denotes how the location related to the company. Includes options for `trade` indicates the address was found in shipping records.


The location `type` attribute currently includes two options:

Type | Description
--------- | ----------- | 
`Trade` | Indicates the address was found in shipping records. | 
`Operating` | Indicates the address was found in corporate records or third party company profiles. |
`Unspecified` | Indicates the address found but no available information on address type. |


## Entity Monitoring Updates 

The monitor entity updates endpoint allows retrieves individual updates for the specified entity. See [pagination](#pagination) section for reference.

```shell
curl "https://api.sigmaratings.com/v1/monitor/updates/entity/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json

  {
  "id": "urn:sigma:entity:9699f250-65e8-42be-9a92-c5bbf7cf82af",
  "updates": [
    {
      "type": "added",
      "field": "indicator",
      "value": {
        "id": "urn:sigma:indicator:XldOgLi_nFCDCw6Co5MDMrJcxIQ_ySwd_kX-JQh-Lbg=",
        "name": "Business locations in HIGH risk countries",
        "score": 40,
        "category": "Jurisdiction",
        "description": "Gazpurinvest Ooo operates in: Russia. High risk jurisdiction(s) based on Sigma Country Risk Ratings",
        "source_urls": []
      }
    },
    {
      "type": "updated",
      "field": "indicator",
      "value": {
        "id": "urn:sigma:indicator:-1630dLcKwQIVVj26LZBraKJr7bQYjbsLil9zI57eQg=",
        "name": "Business locations in HIGH risk countries",
        "score": 40,
        "category": "Jurisdiction",
        "description": "Gazprom, Oao operates in: Russia. High risk jurisdiction(s) based on Sigma Country Risk Ratings",
        "source_urls": []
      }
    }
  ]
}
```

### HTTP Request

`GET https://api.sigmaratings.com/v1/monitor/updates/entity/:id`

### Query Parameters

Parameter |  Description | Type | Default
--------- |  ----------- | ------- | ----------
`since` | `YYYY-MM-DD` formatted string timestamp | string | 
`to` | `YYYY-MM-DD` formatted string timestamp | string | 
`page` | See [pagination](#pagination) section for reference. | string | 

### Response details

Field |  Description 
--------- |  -----------
`entity_id` | A unique identifier for the entity.
`updates` | An array of individual updates. See description below.

_**Updates**_

Field |  Description 
--------- |  -----------
`type` | The `type` attribute can be one of: `added`, `deleted`, `updated`.mation on address type. 
`field` | The field that was modified.
`value` | The value that was modified. Each field for the value object is defined below:

Field | Description
--------- | ----------- | 
`id` | A unique identifier for the value that was modified.
`name` | Name of the field that was modified.
`score` | Risk score of the field that was modified.
`category` | One of [available categories](#available-indicators) for the field that was modified.
`description` | Description of the field that was modified.
`source_urls` | Source url of field that was modified if present.


## Bulk Monitoring Updates

Bulk updates allows the bulk retrieval of all updates per bulk id. See [pagination](#pagination) section for reference.

```shell
curl "https://api.sigmaratings.com/v1/monitor/updates/bulk/:id"
  -H "Authorization: mZGVtbzpwQDU1dzByZA=="
```

> The above command returns JSON structured like this:

```json

  {
  "bulk_id": "f557cc90-71c8-43b7-a7b1-f82923099f69",
  "updates": [
    {
      "id": "urn:sigma:entity:18968802-56e0-47d6-9adc-d708f1a51137",
      "type": "updated",
      "field": "indicator",
      "value": {
        "id": "urn:sigma:indicator:eHPKQdGUSoGJhkBt-NGj-oVhLyAH7LVG7pQf9QDlxiE=",
        "name": "Business locations in HIGH risk countries",
        "score": 40,
        "category": "Jurisdiction",
        "description": "operates in: Kenya. High risk jurisdiction(s) based on Sigma Country Risk Ratings",
        "source_urls": []
      },
      "timestamp": "2021-06-24T10:35:20.079536Z"
    }
  ],
  "next": null,
  "previous": null,
  "total": 1
}
```

### HTTP Request

`GET https://api.sigmaratings.com/v1/monitor/updates/bulk/:id`

### Response details

Field |  Description 
--------- |  -----------
`bulk_id` | A unique identifier for the group of related entities.
`updates` | An array of individual updates. See description below.
`next` | Indicates a positive integer to the next page of results.
`previous` | Indicates a positive integer to the previous page of results.
`total` | Indicates total number of updates.

_**Updates**_

Field |  Description 
--------- |  -----------
`id` | A unique identifier for the entity.
`timestamp` | A timestmap indicating when the update was created.
`type` | The `type` attribute can be one of: `added`, `deleted`, `updated`.mation on address type. 
`field` | The field that was modified.
`value` | The value that was modified. Each field for the value object is defined below:

Field | Description
--------- | ----------- | 
`id` | A unique identifier for the value that was modified.
`name` | Name of the field that was modified.
`score` | Risk score of the field that was modified.
`category` | One of [available categories](#available-indicators) for the field that was modified.
`description` | Description of the field that was modified.
`source_urls` | Source url of field that was modified if present.

