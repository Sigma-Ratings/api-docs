# Pagination

<aside class="notice">
The following section describes how to use pagination when available. 
</aside>

If an endpoint supports pagination the response will include the following fields:

Field | Description | Default
---------- | ------- | ----------
`next` | A positive integer indicating the next available page. | Null if not available
`previous` | A positive integer indicating the previous available page. | Null if not available
`total` | Total number of records | 

To navigate to the `next` or `previous` page, specify the `page` query parameter in the request.

``` 
curl  'https://api.sigmaratings.com/v1/monitor/updates/bulk/424ff463-fd9b-4df8-99d8-f5ce2146502e?page=1' \
  --header 'Authorization: Basic NmIzNjRiODQ3MTY3NjAzOWYwZDQ2YzkzZTNlMThhZDliMjZkNjhmZTJiMDA1Zjc2YjhlNGJhZWRhNWViNmRjZDo=' \
  --header 'Content-Type: application/json'
```