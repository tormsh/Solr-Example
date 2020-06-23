# Solr example for nested queries

This repository contains a docker container with Solr and sample data to reproduce issues regarding the Block Join Parent Query Parser.

To build and run the container issue the following commands:

```
docker build -t solr-example .
docker run -p 8983:8983 solr-example
```

The solr collection in the container already contains the following document:

```json
{
    "id": "1",
    "class": "composition",
    "children": [
        {
            "id": "2",
            "class": "section",
            "children": [
                {
                    "id": "3",
                    "class": "observation"
                }
            ]
        },
        {
            "id": "4",
            "class": "section",
            "children": [
                {
                    "id": "5",
                    "class": "instruction"
                }
            ]
        }
    ]
}
```

# Example queries

[The following SOLR query (click on the link)](http://localhost:8983/solr/Collection/select?q=%7B!parent%20which%3D%27id%3A4%27%7Did%3A5):
```
{!parent which='id:4'}id:5
```
Returns the expected result:
```json
{
  "responseHeader":{
    "status":0,
    "QTime":61,
    "params":{
      "q":"{!parent which='id:4'}id:5",
      "_":"1592916702678"}},
  "response":{"numFound":1,"start":0,"docs":[
      {
        "id":"4",
        "class":"section",
        "_nest_path_":"/children#1",
        "_nest_parent_":"1",
        "_root_":"1",
        "_version_":1670292333456785408}]
  }}
```

[The following SOLR query (click on the link)](http://localhost:8983/solr/Collection/select?q=%7B!parent%20which%3D%27id%3A4%27%7Did%3A3):
```
{!parent which='id:4'}id:3
```
Returns the same result as the previous which is not expected:
```json
{
  "responseHeader":{
    "status":0,
    "QTime":2,
    "params":{
      "q":"{!parent which='id:4'}id:3",
      "_":"1592916890091"}},
  "response":{"numFound":1,"start":0,"docs":[
      {
        "id":"4",
        "class":"section",
        "_nest_path_":"/children#1",
        "_nest_parent_":"1",
        "_root_":"1",
        "_version_":1670292333456785408}]
  }}
  ```

We expect the result to be empty as document 3 is not a child document of document 4.

