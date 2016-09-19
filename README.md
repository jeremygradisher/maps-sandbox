#Maps Sandox
Sandbox using Leaflet and leaflet.draw to create Maps/Areas
This was rebuilt from https://github.com/jeremygradisher/leaflet-sandbox which was basically markers as opposed to areas.

**leaflet.draw - https://github.com/Leaflet/Leaflet.draw
example: http://leaflet.github.io/Leaflet.draw/

---
#If cloning this realize a couple of things:

-it's using sqlite3 in development and PostgreSQL in production (gemfile)

-it uses AWS for file storage - just needs an S3 bucket and credentials<br>
$ heroku config:set S3_ACCESS_KEY=xxxxxxxxxxxxxxxxxx<br>
$ heroku config:set S3_SECRET_KEY=xxxxxxxxxxxxxxxxxx<br>
$ heroku config:set S3_BUCKET=xxxxxxxxxxxxxxxxxx

-it uses imagemagick for getting the width/height on upload

---

#Amazon/AWS notes
75. Sign up for Amazon web services at aws.amazon.com<br>
Follow the video exactly as shown:<br>
    1) Create IAM user and grab the keys:<br>

    user: bucketname<br>
    Access Key ID:<br>
    xxxxxxxxxxxxxxxx<br>
    Secret Access Key:<br>
    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo<br>

    2) Create S3 bucket<br>
      Under services hit S3<br>
      Push Create bucket - name the bucket and select the region (mapsbucket)<br>
      *make note of the region:<br>
      Bucket: bucketname<br>
      Region: US Standard<br>
      Creation Date:  Tue Sep 06 16:06:30 GMT-400 2016<br>
      Owner:  michael<br>

    3) Go back to services and click IAM hit users in the left nav and click into the user

    4) hit policies in the left click get started (if neccessarry) 

    5) click create policy

    6) Copy an AWS Managed Policy select

    7) search AdministratorAccess and select


    8) Attach policy to IAM user created<br>
    Here is a sample policy, replace the code with your s3 bucket name as needed below:<br>
    {<br>
    "Version": "2012-10-17",<br>
    "Statement": [<br>
    {<br>
                "Effect": "Allow",<br>
                "Action": "s3:*",<br>
                "Resource": [<br>
                "arn:aws:s3:::bucketname",<br>
                "arn:aws:s3:::bucketname/*"<br>
                ]<br>
    },<br>
    {<br>
    "Effect": "Allow",<br>
    "Action": "s3:ListAllMyBuckets",<br>
    "Resource": "arn:aws:s3:::*"<br>
    }<br>
    ]<br>
    }<br>

    9) click create policy

    10) go to users and attach the policy under permissions attach policy

76. Set your credentials for amazon IAM user and S3 bucket with heroku:<br>
$ heroku config:set S3_ACCESS_KEY=youraccesskeyforIAMuser<br>
$ heroku config:set S3_SECRET_KEY=yoursecretykeyforIAMuser<br>
$ heroku config:set S3_BUCKET=yours3bucketname<br>



77. create config/initializers/carrier_wave.rb<br>
if Rails.env.production?<br>
    CarrierWave.configure do |config|<br>
        config.fog_credentials = {<br>
            :provider => 'AWS',<br>
            :aws_access_key_id => ENV['S3_ACCESS_KEY'],<br>
            :aws_secret_access_key => ENV['S3_SECRET_KEY']<br>
            }<br>
        config.fog_directory = ENV['S3_BUCKET']<br>
    end<br>
end<br>

---
#imagemagick notes
###I had issues getting imagemagick to work - here it what helped:<br>
79. needed imagemagick for getting width/height on upload<br>
  1. Update apt-get packages inside the C9 terminal<br>
  $ sudo apt-get update <br>

  2. Install imagemagick command-line tools via apt-get<br>
  $ sudo apt-get install imagemagick<br>

80. shelling out manually:<br>
https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Get-image-dimensions