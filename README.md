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

---

##Additional notes from my initial build:

maps-sandbox.txt

1. Set-up new workspace in Cloud9

2. Change readme.md to a brief description of your app.
#turn on the server and preview

3. $ rails generate controller home index
*This generates a home controller with an index action

4. Change get 'home/index' within the config/routes.rb file to: root 'home#index'
*Then test out the preview to insure that you are good!
**You can update the page as you need, you can find this index view in the 
app/views/home folder in a file called index.html.erb

5. Create a github repository in your github account for this app (github.com)
Initialize a git repo for the app and make a commit
  1. $ git init
  2. $ git add -A
  3. $ git commit -m "Initial commit"
  4. $ git remote add origin https://github.com/xxxxxxxxxxxxxxxxxxxxxxxxx
      *You obviuosly need to use your own link from the github page.
  5. $ git push -u origin master
  6. It will prompt and ask for your username/email and password.

6. Prepare the app for deployment to heroku by moving the sqlite3 gem to group development 
and then creating a group production and adding the gems necessary below it:

Add this to the bottom of your gemfile (after the group development)

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

7. move gem 'sqlite3' to group :development, :test do - as follows:
group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
end

8. $ bundle install --without production

9. Create a heroku app by using:
$ heroku create

10. Rename the app to something you like by using 
$ heroku rename nameofyourchoice

11. Ensure your latest changes are committed using git status, if not, make a commit

12. To deploy your app to production:
$ git push heroku master

13. Then test out the URL to view your app in production


14. Add the following gems to the gemfile (Right after gem 'rails', '4.2.5'):
gem 'devise'
gem 'twitter-bootstrap-rails'
gem 'devise-bootstrap-views'
gem 'bootstrap-datepicker-rails'

15. Then run $ bundle install --without production

16. Then install devise:
$ rails generate devise:install
$ rails generate devise User

*didn't do these - I don't want to confirm for the sandbox
        17. Pull up the db/migration file that just got created and uncomment the 4 lines under confirmable:
        t.string :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string :unconfirmed_email

        18. Pull up the user.rb model file under app/models and in the line for devise, add in a:
        :confirmable,
        after :registerable,

19. Run your migration now to create the users table:
$ rake db:migrate

**Note here if I attempt to view the app I get:
undefined method `devise_for' for #<ActionDispatch::Routing::Mapper:0x007fcbf8ca4240>

20. I can fix it by altering that devise_for line that was generated within routes.rb

devise_for :users, :controllers => { :registrations => 'devise/registrations' }
*and then restarting my server. not really sure if that is right.

20. In your application_controller.rb file under app/controllers add in (Added after protect_from_forgery with: :exception):
before_action :authenticate_user!

      21. In your home_controller.rb file under app/controllers add in:
      #skip_before_action :authenticate_user!, only: [:index]
      *I have this commented out for the moment.

22. Run the following generators to install bootstrap themed styling:
$ rails generate bootstrap:install static
$ rails generate bootstrap:layout application # select Y to force override after hitting enter
$ rails generate devise:views:locale en
$ rails generate devise:views:bootstrap_templates

23. In the application.css file under app/assets/stylesheets folder, 
right above the line that says *= require_tree add in the following line:
*= require devise_bootstrap_views

      *you must have credit card details entered in heroku account to use sendgrid
      24. 
      $ heroku addons:create sendgrid:starter

      25. Refresh Heroku dashboard and notice the sendgrid stuff added at the bottom,
      click on Sendgrid, within the left navigation, navigate to settings/credentials
      and then add new credentials, select the Mail option and create creditials.

      26. Set the sendgrid credentials you created for heroku:
      $ heroku config:set SENDGRID_USERNAME=enterintheusername
      $ heroku config:set SENDGRID_PASSWORD=enterinthepassword
      **you can check this with $ heroku config
      ***To display your settings you can type in:
      $ heroku config:get SENDGRID_USERNAME


      27. Open your .bashrc file and enter in the following as well:
      export SENDGRID_USERNAME=xxxxxx
      export SENDGRID_PASSWORD=xxxxxxxxxx
      *you may have to go to settings icon and show hidden files and home folder to find it

      28. Under config/environment.rb file add in the following code at the bottom:
      ActionMailer::Base.smtp_settings = {
        :address => 'smtp.sendgrid.net',
        :port => '2587',
        :authentication => :plain,
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :domain => 'heroku.com',
        :enable_starttls_auto => true
      }

      *This line: :port => '2587', that number should be 2587 when signing someone up on Cloud9, and 587 before you deploy it to Heroku.
      **Leaving that as 2587 and not changing to 587 before deploying to Heroku will cause Heroku to throw an error when you are trying to register.

      29. Open a new terminal and restart your server for changes to take effect

      30. Now update the development.rb file under config/environments folder and add the following two lines:
      config.action_mailer.delivery_method = :test
      config.action_mailer.default_url_options = { :host => 'http://previewurlforyourapp'}

      My preview url looks like this: http://ruby-on-rails-123170.nitrousapp.com:3000

      31. Now update the production.rb file under config/environments folder and add the following two lines:
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.default_url_options = { :host => 'yourherokuappname.herokuapp.com', :protocol => 'https'}

32. restart server and test on IDE
Test it out in development by signing up a user and then grabbing the confirmation link from the web output 
in your terminal and copying/pasting the link in your browser

33. Go to application.html.erb file under app/views/layouts folder and remove the sidebar code, then add in the following right after the </ul> tag after Link3:

          <ul class="nav navbar-right col-md-4">
            <% if current_user %>
              <li class="col-md-8 user-name">
              <%= link_to ('<i class="fa fa-user branded-orange"></i> <span class="branded-orange">' + truncate(current_user.email, length: 25)).html_safe,
              edit_user_registration_path, title: 'Edit Profile' %>
              </li>
              <li class="col-md-1"> </li>
              <li class="col-md-3 logout"><%= link_to('Logout', destroy_user_session_path,
              class: 'btn btn-xs btn-danger btn-danger-altered', title: 'Logout', :method => :delete) %></li>
            <% else %>
              <li class="col-md-4 pull-right">
              <%- if controller_name == 'sessions' %>
                <div style="height:41px;clear:both;margin-top:5%;margin-bottom:5%;"></div>
              <% else %>
              <%= link_to('Sign In', new_user_session_path, class: 'btn btn-primary btn-primary-altered', title: 'Sign In') %>
              <% end %>
              </li>
            <% end %>
          </ul>

34. Create a file under app/assets/stylesheets folder called custom.css.scss 
and fill it in with the following(edit as you need):
.user-name {
padding: 0 !important ;
padding-left: 5px;
padding-top: 15px !important;
text-align: center;
a {
color: black !important;
margin: 0 !important;
padding: 5px!important;
}
a:hover, a:focus {
color: #000 !important;
}
}
.logout {
padding-left: 0;
}
.nav.navbar-right {
padding-bottom: 10px;
padding-top: 5px;
}
.nav.navbar-nav {
.navbar-link {
border-radius: 5px;
color: #fff;
margin-top: 15px;
padding: 8px;
}
.navbar-link:focus, .navbar-link:hover {
background: #3071a9;
color: #fff;
}
li a {
margin-right: 5px;
}
}
.nav.navbar-right li {
.btn {
color: #fff !important;
margin-top: 5%;
}
.btn-danger:hover, .btn-danger:focus {
background-color: darken(#d9534f,20%) !important;
}
.btn-primary:hover, .btn-primary:focus {
background-color: darken(#428bca,20%) !important;
}
}
.btn-primary:visited, .btn-danger:visited {
color: #fff;
}




.form-control-image {
    vertical-align: top;
    height:18pt;
    margin-top:0;
    margin-bottom:0;    
    border-radius:4px;
    margin-right:4px;
}

.form-control-button {
    vertical-align: top;
    font-size:20pt;
    line-height:18pt;
    margin-top:0;
    margin-bottom:0;
    margin-right:4px;
}

.form-control {
    height:38px;
}

.form-control-button {
    vertical-align: middle;
    font-size: 16pt; }
    
#area_map_id {
    display: block;
    width: 100%;
    height: 34px;
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
    -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}

      35. Open your devise.rb file under config/initializers folder and change the from address in the line:
      config.mailer_sender = 'changethis@example.com'

      36. Changed the port back to 587 in config/locales/environment.rb
      ***587 is the natural port number for mailing. 587 is blocked by default by Cloud9 so we use 2587 (For Cloud9 only)

      ActionMailer::Base.smtp_settings = {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :authentication => :plain,
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :domain => 'heroku.com',
        :enable_starttls_auto => true
      }

37. Git commit to get our repository up to date
$ git add -A
$ git commit -m "Completed Devise set-up"
$ git push

38. Deploy to heroku
$ git push heroku master

39. Run all your pending migrations in production
$ heroku run rake db:migrate

40. I did restart all dynos - not sure if that was neccessarry.
$ heroku restart -a maps-sandbox-ws

41. Test user sign up on Heroku

42. remove turbolinks - 
  1. in app/assets/javascripts/application.js 
  remove: //= require turbolinks
  2. in gemfile comment out or remove:
  gem 'turbolinks'
  3. $ bundle install --without production

43. Git commit to get our repository up to date
$ git add -A
$ git commit -m "removed turbolinks"
$ git push

44. Deploy to heroku
$ git push heroku master


Create users index:
45. routes.rb add:
  resources :users, :only => [:index, :show, :destroy]
  right after the other devise stuff: devise_for :users, :controllers => { :registrations => 'devise/registrations' }


46. create users controller
$ rails generate controller users index show

open it up and add all of this:
class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end

47. add this to the index:
<table class="table table-striped">
  <thead>
    <tr>
      <th>ID:</th>
      <th>Users:</th>
      <th>Last Signed in at:</th>
      <th><%=t '.actions', :default => t("helpers.actions") %></th>
    </tr>
  </thead>
  <tbody>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.id %></td>
        <td><%= user.email %></td>
        <td><%= user.last_sign_in_at %></td>
        <td>
          <%= link_to t('.view', :default => t("helpers.links.view")),
                      user_path(user), :class => 'btn btn-default btn-xs' %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>

<div class="col-lg-12" style="text-align:left;">
  <hr>
      <%= link_to t('.back', :default => "<= Back to Home"),
              root_path, :class => 'btn btn-primary'  %>
  <hr>
</div>

49. add this to the show:
<table class="table table-striped">
  <thead>
    <tr>
      <th>Users:</th>
      <th>Last Signed in at:</th>
      
      <th><%=t '.actions', :default => t("helpers.actions") %></th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td><%= @user.email %></td>
        <td><%= @user.last_sign_in_at %></td>
        <td>
          <%= link_to t('.destroy', :default => t("helpers.links.destroy")),
                      user_path(@user),
                      :method => 'delete',
                      :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
                      :class => 'btn btn-danger btn-xs' %> 
        </td>
      </tr>
  </tbody>
</table>

<div class="col-lg-12" style="text-align:center;">
  <hr>
      <%= link_to t('.back', :default => "<= Back to Users"),
              users_path, :class => 'btn btn-default'  %>
    <%= link_to t('.back', :default => t("helpers.links.home")),
              root_path, :class => 'btn btn-primary'  %>
  <hr>
</div>



50. add the users link to the top nav:
<li><%= link_to "Users", users_path  %></li>

51. git push...

$ git add -A
$ git commit -m "Devise set-up with user index, bootstrap styling"
$ git push
$ git push heroku master


52. add leaflet to the gemfile
gem 'leaflet-rails'

$ bundle install --without production


53. open your application-wide CSS file (app/assets/stylesheets/application.css) and add the following line as a comment:
*= require leaflet

54. open your application-wide Javascript file (typically app/assets/javascripts/application.js) and add the following line before requiring files which depend on Leaflet:
//= require leaflet


55. Git push...




56. Create Areas model
$ rails generate scaffold Area name:string info:text status:string coords:string map_id:integer
$ rake db:migrate
$ rails g bootstrap:themed Areas
*(Y) for all of the conflicts

57. Create Maps model
$ rails generate scaffold Map name:string
$ rake db:migrate
$ rails g bootstrap:themed Maps
*(Y) for all of the conflicts



make sure carrierwave is installed!
58. Add the following gems to your gemfile under gem 'coffee-rails', '~> 4.1.0':
    gem 'carrierwave'
    gem 'mini_magick'
    gem 'fog'

59. $ bundle install --without production


60. add-another-uploader.txt

61. $ rails generate uploader Image

62. $ rails generate scaffold image map_id:integer image:string width:string height:string

63. $ rake db:migrate

64. In app/models/map.rb (I two at the top):
class Map < ActiveRecord::Base
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images
    has_many :areas, dependent: :destroy
    accepts_nested_attributes_for :areas
end

65. In app/models/image.rb
class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :map
  validates_size_of :image, maximum: 2.megabytes, message: "Upload should be less than 2MB"
end

66. in app/models/area.rb
class Area < ActiveRecord::Base
  belongs_to :map
end

67. In app/controllers/maps_controller.rb
class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
    #added this so I can get the image to be used as the map
    @image = @map.images.first
    @images = @map.images.all
    #added this next line - trying to figure it out
    @areas = @map.areas.all
  end

  # GET /maps/new
  def new
    @map = Map.new
    @image = @map.images.build
    @images = @map.images.all
  end

  # GET /maps/1/edit
  def edit
    @image = @map.images.build
    @images = @map.images.all
  end

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(map_params)

    respond_to do |format|
      if @map.save
        if params.has_key?(:images)
           params[:images]['image'].each do |a|
              @image = @map.images.create!(:image => a)
           end
        end
        format.html { redirect_to @map, notice: 'Map was successfully created.' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)
        if params.has_key?(:images)
           params[:images]['image'].each do |a|
              @image = @map.images.create!(:image => a)
           end
        end
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.require(:map).permit(:name, images_attributes: [:id, :map_id, :image, :width, :height])
    end
end


67. In views/maps/_form.html.erb (Add it above the submit button):
<%= form_for @map, :html => { :class => "form-horizontal map" } do |f| %>

  <% if @map.errors.any? %>
    <div id="error_expl" class="panel panel-danger">
      <div class="panel-heading">
        <h3 class="panel-title"><%= pluralize(@map.errors.count, "error") %> prohibited this map from being saved:</h3>
      </div>
      <div class="panel-body">
        <ul>
        <% @map.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    </div>
  <% end %>

  <div class="form-group">
    <%= f.label :name, :class => 'control-label col-lg-2' %>
    <div class="col-lg-10">
      <%= f.text_field :name, :class => 'form-control' %>
    </div>
    <%=f.error_span(:name) %>
  </div>
  
  <div class="form-group">  
    <% if @images.exists? %>
      <%= f.label :map_image, :class => 'control-label col-lg-2'  %>
        <div class="col-lg-10">
          <% @images.each do |p| %>
                <div class="form-control">
                  <%= image_tag p.image_url, :class => 'form-control-image' %>

                <%= link_to '<i class="fa fa-edit"></i>'.html_safe,
                      edit_image_path(p), :class => 'form-control-button', 
                      :title => 'Edit Attachment'  %>
                </div>
                
          <% end %>
        </div>
    
    <% else %>  
         <%= f.label :map_image, :class => 'control-label col-lg-2'  %>
         <div class="col-lg-10">
         <%= f.file_field :image, :multiple => true, name: "images[image][]", :class => 'form-control' %>
         </div>
    <% end %>
  </div>  
  
  <div class="form-group">
    <div class="col-lg-offset-2 col-lg-10">
      <%= f.submit nil, :class => 'btn btn-primary' %>
      <%= link_to t('.cancel', :default => t("helpers.links.cancel")),
                maps_path, :class => 'btn btn-default' %>
    </div>
  </div>

<% end %>

68. To edit an attachment and list of attachments for map. In views/maps/show.html.erb:
***This has been altered!!!!

<div class="col-lg-12">
  <% @images.each do |p| %>
        <%= image_tag p.image_url, :style => 'max-width:90%;padding:5%;' %><br>
        
        <div style="margin-left:auto;margin-right:auto;text-align:center;">
        <%= link_to '<i class="fa fa-edit"></i>'.html_safe,
              edit_image_path(p), :class => 'btn btn-primary', 
              :title => 'Edit Attachment'  %>
        <%#= link_to "Destroy Attachment", destroy_associate_attachment_path(p) %>
        <%= link_to '<i class="fa fa-remove"></i>'.html_safe,
              image_path(p),
              :method => 'delete',
              :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
              :class => 'btn btn-danger', :title => 'Delete Attachment'  %>
        </div>
        
  <% end %>
</div>

69. Update form to edit an attachment views/images/_form.html.erb:
<%= image_tag @image.image, :style => 'max-width:300px;padding:20px;' %>
  <%= form_for(@image) do |f| %>
    <% if @image.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@image.errors.count, "error") %> prohibited this image from being saved:</h2>

      <ul>
      <% @image.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>
    <div class="field">
      <%= f.label :image %><br>
      <%= f.file_field :image, :id => "image_picture" %>
    </div>
    <div class="actions">
      <%= f.submit %>
    </div>
<% end %>


70. Modify update and destroy methods in image_controller.rb:
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image.map, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to @image.map, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

71. In your image_uploader.rb file under app/uploaders folder, right around line 9 alter the storage :file:
  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

72. In app/uploaders/image_uploader.rb file uncomment the following lines (41-43):
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  or

  def extension_white_list
   %w(pdf doc docx jpg jpeg gif png tif)
  end


73. app/views/images/edit.html.erb:
<h1>Editing Project Image</h1>

<%= render 'form' %>

<%#= link_to 'Show', @image %> |
<%#= link_to 'Back', images_path %>
<%= link_to t('.back', :default => t("helpers.links.back")),
              @image.map, :class => 'btn btn-default'  %>

74. git push
$ git add -A
$ git commit -m "added another uploader image"
$ git push

$ git push heroku master
$ heroku run rake db:migrate
$ heroku restart -a workshopcrm



75. Sign up for Amazon web services at aws.amazon.com
Follow the video exactly as shown:
    1) Create IAM user and grab the keys:

    user: bucketname
    Access Key ID:
    xxxxxxxxxxxxxxxx
    Secret Access Key:
    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    2) Create S3 bucket
      Under services hit S3
      Push Create bucket - name the bucket and select the region (mapsbucket)
      *make note of the region:
      Bucket: bucketname
      Region: US Standard
      Creation Date:  Tue Sep 06 16:06:30 GMT-400 2016
      Owner:  michael

    3) Go back to services and click IAM hit users in the left nav and click into the user

    4) hit policies in the left click get started (if neccessarry) 

    5) click create policy

    6) Copy an AWS Managed Policy select

    7) search AdministratorAccess and select


    8) Attach policy to IAM user created
    Here is a sample policy, replace the code with your s3 bucket name as needed below:
    {
    "Version": "2012-10-17",
    "Statement": [
    {
                "Effect": "Allow",
                "Action": "s3:*",
                "Resource": [
                "arn:aws:s3:::bucketname",
                "arn:aws:s3:::bucketname/*"
                ]
    },
    {
    "Effect": "Allow",
    "Action": "s3:ListAllMyBuckets",
    "Resource": "arn:aws:s3:::*"
    }
    ]
    }

    9) click create policy

    10) go to users and attach the policy under permissions attach policy

76. Set your credentials for amazon IAM user and S3 bucket with heroku:
$ heroku config:set S3_ACCESS_KEY=youraccesskeyforIAMuser
$ heroku config:set S3_SECRET_KEY=yoursecretykeyforIAMuser
$ heroku config:set S3_BUCKET=yours3bucketname



77. create config/initializers/carrier_wave.rb
if Rails.env.production?
    CarrierWave.configure do |config|
        config.fog_credentials = {
            :provider => 'AWS',
            :aws_access_key_id => ENV['S3_ACCESS_KEY'],
            :aws_secret_access_key => ENV['S3_SECRET_KEY']
            }
        config.fog_directory = ENV['S3_BUCKET']
    end
end

    *These were addressed above!
    78. create :has_many and :belongs_to associations - 
    ***If you create an association some time after you build the underlying model, 
    you need to remember to create an add_column migration to provide the necessary foreign key.
      1. added belongs_to :map
      2. added has_many :areas
      3. add_column migration map_id to area:
      $ rails generate migration AddMapIDToAreas map_id:integer
      $ rake db:migrate


79. needed imagemagick for minimagick and getting width/height on upload
  1. Update apt-get packages inside the C9 terminal
  $ sudo apt-get update 

  2. Install imagemagick command-line tools via apt-get
  $ sudo apt-get install imagemagick

80. shelling out manually:
https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Get-image-dimensions

81. make sure you have the image markers in there!

82. make sure you have transfered all the files in app/views/maps and app/views/areas

83. git push...

*ready for leaflet.draw

84. Uploaded pictures (3) into public/images

85. altered the css to find those tool images

86. added the javascript file to app/assets/javascripts

87. //= require leaflet-draw
added to app/assets/javascripts/application.js right after //= require leaflet

88. added the css file to app/assets/stylesheets

89. *= require leaflet-draw 
added to app/assets/javascripts/application.css right after *= require leaflet

90. made changes to the views/maps and views/areas to get the javascript right...

