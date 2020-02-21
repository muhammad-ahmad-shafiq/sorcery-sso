This app has enabled SSO integration with an open source platform i.e. Discourse.

# Dependencies
* Ruby
* Rails
* Bundler
* Postgresql

# Setup

* Clone the project
* Install required ruby version
* Install gems by running: `bundle install`
* Setup database: `rails db:create db:migrate`
* Run server by: `rails server -b 0.0.0.0 -p 9292`


# Test
## Setup discourse
You need to setup the discourse project on local machine.
[https://github.com/discourse/discourse/blob/master/docs/DEVELOPER-ADVANCED.md](https://github.com/discourse/discourse/blob/master/docs/DEVELOPER-ADVANCED.md)
After this, setup an admin just like described.
After signing in, enables SSO in the discourse project.[https://meta.discourse.org/t/official-single-sign-on-for-discourse-sso/13045](https://meta.discourse.org/t/official-single-sign-on-for-discourse-sso/13045)

`enable_sso = true`
`sso_url = http://localhost:9292/discourse/sso`
`sso_secret = abcdefghij`

## Setup our app
Setup this project like described above.
I haven't configured mailer that's why Sorcery will send email when user is created. So by default, user is inactive. If you are going to create user, you need to activate it from console.

## Test SSO login
Now you can go to your Discourse screen [http://localhost:3000] and then click on login button. It will redirect to our app i.e. [http://localhost:9292]. Now if user is already signed in, it will redirect back to Discourse sending required params in encrypted form
If user is not already signed in, it will redirect to login page of our page i.e. [http://localhost:9292/login] and after log in, it will redirect to Discourse.

