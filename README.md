# Text A Coach: Backend

This application is the backend & API that powers the text-a-coach website. It is available at:

https://text-a-coach-backend.herokuapp.com/

## Admin

The administration panel is accessible at:

https://text-a-coach-backend.herokuapp.com/admin/

## API

The API is accessible at:

https://text-a-coach-backend.herokuapp.com/api/v1/


## Local Setup

Requirements:
- Ruby
- [Postgres](http://postgresapp.com/) 9.x
- ENV File (copy `.env.example` to `.env` in project)

Get your local environment setup:

```
cd /path/to/project
gem install bundler
bundle install
rake db:setup
rake db:migrate
rake db:seed
```

Connect the repo to the Heroku app:

```
heroku login
heroku git:remote -a text-a-coach-backend
```

Run the application:
```
heroku local
```

Your app should be available at http://localhost:3333/

## Production Deploy

**One-Time Setup**

Make sure you have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed and you are logged in.

Set up your repo for the Heroku app:
```
cd /path/to/textacoach-backend
heroku login
heroku git:remote -a text-a-coach-backend
```

**Deploy Step**

To deploy to production, ensure you are checked out on the latest from the `master` branch and simply run:
```
git push heroku master
```

**Rake Tasks**

If you need to run rake tasts (e.g. `db:migrate`) simply run the following from the project dir:
```
heroku run rake db:migrate -a text-a-coach-backend
```

## Heroku Config

Add any necessary config info here.
