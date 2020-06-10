This module by default does not expose the port for the admin console.  You will have to add 
that manually in the console. 

This module will output the password and associated information in a json object in s3. 
Go to terraform-states-1234567891023 bucket and navigate to the json. Then open the json and in 
the `outputs` field there should be the password you need. 