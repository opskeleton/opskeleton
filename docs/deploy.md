# Deployment

The packaged tar files can be consumed using any tool and protocol (http, s3 etc),  opsk has built in support for deploying public sandboxes into:

* Bintray 

  ```bash 
   $ opsk package
   $ opsk deploy_bintray <bintray-repo>
     deployed foo-sandbox-0.0.1.tar.gz to http://dl.bintray.com/narkisr/<bintray-repo>/foo-sandbox-0.0.1.tar.gz
```

  Make sure to  [configure](https://github.com/narkisr/bintray-deploy#usage) the bintray API key.

* S3:

  ```bash 
   $ opsk package
   $ opsk deploy_s3 <bucket> <path>
     deployed foo-sandbox-0.0.1.tar.gz to opsk-boxes/foo/foo-sandbox-0.0.1.tar.gz
  ```
 Make sure to configure s3 section under ~/.configuration.rb:

 ```ruby
  Configuration.for('s3') {
    access_key ''
    secret_key ''
    region ''
  }
 ```




