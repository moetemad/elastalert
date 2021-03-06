# ElastAlert Server

> A server that runs [ElastAlert](https://github.com/Yelp/elastalert) and exposes REST API's for manipulating rules and alerts. It works great in combination with our [ElastAlert Kibana plugin](https://github.com/bitsensor/elastalert-kibana-plugin).

![GitHub release](https://img.shields.io/github/release/bitsensor/elastalert.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/bitsensor/elastalert.svg)
![GitHub stars](https://img.shields.io/github/stars/bitsensor/elastalert.svg?style=social&label=Stars)

---

## Installation
The most convenient way to run the ElastAlert server is by using our Docker container image. The default configuration uses `localhost:9200` as ElasticSearch host, if this is not the case in your setup please edit `es_host` and `es_port` in both the `elastalert.yaml` and `config.yaml` configuration files.

## Building Docker image

Clone the repository
```bash
git clone https://github.com/moetemad/elastalert.git && cd elastalert
```

Build the image
```
docker build .
```
## Configuration
In `config/config.yaml` you'll find the default config. Change this file based on your needs. There is also a config/elastalert.yaml that should be changed. 

## API
This server exposes the following REST API's:

- **GET `/`**

    Exposes the current version running
  
- **GET `/status`**

    Returns either 'SETUP', 'READY', 'ERROR', 'STARTING', 'CLOSING', 'FIRST_RUN' or 'IDLE' depending on the current ElastAlert process status. 
  
- **GET `/status/control/:action`**

    Where `:action` can be either 'start' or 'stop', which will respectively start or stop the current ElastAlert process.
  
- **[WIP] GET `/status/errors`**

    When `/status` returns 'ERROR' this returns a list of errors that were triggered.
  
- **GET `/rules`**

    Returns a list of directories and rules that exist in the `rulesPath` (from the config) and are being run by the ElastAlert process.
  
- **GET `/rules/:id`**

    Where `:id` is the id of the rule returned by **GET `/rules`**, which will return the file contents of that rule.
  
- **POST `/rules/:id`**

    Where `:id` is the id of the rule returned by **GET `/rules`**, which will allow you to edit the rule. The body send should be:
  
      ```javascript
      {
        // Required - The full yaml rule config.
        "yaml": "..."
      }
      ```
    
- **DELETE `/rules/:id`**

    Where `:id` is the id of the rule returned by **GET `/rules`**, which will delete the given rule.

- **GET `/templates`**

    Returns a list of directories and templates that exist in the `templatesPath` (from the config) and are being run by the ElastAlert process.
  
- **GET `/templates/:id`**

    Where `:id` is the id of the template returned by **GET `/templates`**, which will return the file contents of that template.
  
- **POST `/templates/:id`**

    Where `:id` is the id of the template returned by **GET `/templates`**, which will allow you to edit the template. The body send should be:
  
      ```javascript
      {
        // Required - The full yaml template config.
        "yaml": "..."
      }
      ```
    
- **DELETE `/templates/:id`**

    Where `:id` is the id of the template returned by **GET `/templates`**, which will delete the given template.
  
- **POST `/test`**

    This allows you to test a rule. The body send should be:
  
      ```javascript
      {
        // Required - The full yaml rule config.
        "rule": "...",
        
        // Optional - The options to use for testing the rule.
        "options": {
        
          // Can be either "all", "schemaOnly" or "countOnly". "all" will give the full console output. 
          // "schemaOnly" will only validate the yaml config. "countOnly" will only find the number of matching documents and list available fields.
          "testType": "all",
          
          // Can be any number larger than 0 and this tells ElastAlert over a period of how many days the test should be run
          "days": "1"
          
          // Whether to send real alerts
          "alert": false,

          // Return results in structured JSON
          "format": "json",

          // Limit returned results to this amount
          "maxResults": 1000
        }
      }
      ``` 

- **WEBSOCKET `/test`**
    
    This allows you to test a rule and receive progress over a websocket. Send a message as JSON object (stringified) with two keys: `rule` (yaml string) and `options` (JSON object). You will receive progress messages over the socket as the test runs.

- **GET `/metadata/:type`**

    Returns metadata from elasticsearch related to elasalert's state. `:type` should be one of: elastalert_status, elastalert, elastalert_error, or silence. See [docs about the elastalert metadata index](https://elastalert.readthedocs.io/en/latest/elastalert_status.html).

- **GET `/mapping/:index`**

    Returns field mapping from elasticsearch for a given index. 

- **GET `/search/:index`**

    Performs elasticsearch query on behalf of the API. JSON body to this endpoint will become body of an ES search. 

- **[WIP] GET `/config`**

    Gets the ElastAlert configuration from `config.yaml` in `elastalertPath` (from the config).
  
- **[WIP] POST `/config`**

    Allows you to edit the ElastAlert configuration from `config.yaml` in `elastalertPath` (from the config). The required body to be send will be edited when the work on this API is done.

- **[WIP] POST `/download`**
  
    Allows you to download a .tar archive with rules from a given HTTP endpoint. The archive will be downloaded, extracted and removed.
    Please note, body should contain URL pointing to tar archive, with tar extension.	
   
    Usage example:
	
    ```bash
    curl -X POST localhost:3030/download -d "url=https://artifactory.com:443/artifactory/raw/rules/rules.tar"
    ```
        
## Contributing
Want to contribute to this project? Great! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting an issue or a pull request.

**We only accept pull requests on our [GitHub repository](https://github.com/bitsensor/elastalert)!**
 
## Contact
We'd love to help you if you have any questions. You can contact us by sending an e-mail to [dev@bitsensor.io](mailto:dev@bitsensor.io) or by using the [contact info on our website]().
 
## License
This project is [BSD Licensed](../LICENSE.md) with some modifications. Note that this only accounts for the ElastAlert Server, not ElastAlert itself ([ElastAlert License](https://github.com/Yelp/elastalert#license)).

## Disclaimer
We [(BitSensor)](https://www.bitsensor.io) do not have any rights over the original [ElastAlert](https://github.com/Yelp/elastalert) project from [Yelp](https://www.yelp.com/). We do not own any trademarks or copyright to the name "ElastAlert" (ElastAlert, however, does because of their Apache 2 license). We do own copyright over the source code of this project, as stated in our BSD license, which means the copyright notice below and as stated in the BSD license should be included in (merged / changed) distributions of this project. The BSD license also states that making promotional content using 'BitSensor' is prohibited. However we hereby grant permission to anyone who wants to use the phrases 'BitSensor ElastAlert Plugin', 'BitSensor Software' or 'BitSensor Alerting' in promotional content. Phrases like 'We use BitSensor' or 'We use BitSensor security' when only using our ElastAlert Server are forbidden.

## Copyright
Copyright © 2018, BitSensor B.V.
All rights reserved.
