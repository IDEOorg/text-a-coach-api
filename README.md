# Text A Coach - API

TODO: Brief project high-level description.
What is it? What does it do? What can I do with it?

## Background

TODO: Project objectives... How and why it came to be.

## Quick Start

### Local Setup

**Requirements**

To get started, make sure you have the following tools installed and available:

- [Ruby 2.3](https://www.ruby-lang.org/en/)
- [PostgreSQL 9.4](https://www.postgresql.org/)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

**Environment Variables**

Take a look at the file `/.env.example`. Copy it into your project as `/.env` and change any values if necessary.

**Setup Ruby & Database**
```
cd /path/to/project
bundle install
rake db:setup
```

#### Twilio

We use [Twilio](https://www.twilio.com) to send and receive SMS messages.

- Create an account
- Create a [new number](https://www.twilio.com/console/phone-numbers/search)


#### Zendesk

We use [Zendesk](https://zendesk.com) to keep track of and respond to inquiries. Each question creates a support ticket, so the financial planners have an easier time keeping track of and responding to questions.

- Create an account
- Note your custom domain (https://my-domain.zendesk.com)


#### Smooch

We use [Smooch](https://smooch.io/) to connect our SMS messaging with our Zendesk tickets and Webhook autoresponders.

- Create an account
- Create a new App
- Add the [Twilio SMS integration](https://app.smooch.io/integrations/twilio) and follow their steps for configuration
- Add the [Zendesk integration](https://app.smooch.io/integrations/zendesk) and follow their steps for configuration

#### Test it out

Congratulations! At this stage you should be able to send an SMS to your Twilio phone number, which should automatically create a Zendesk support ticket.

Replies to the Zendesk support ticket will be sent back as an SMS!


#### Webhook

You can add an optional webhook from Smooch to our API which will enable autoresponders. These were set up to send automated "welcome" and "after hours" text messgaes to our participants.

For information on the specific responses you can see our webhook controller in: `app/controllers/api/v1/webhooks_controller.rb`

To set up the webhook:

- Go to your Smooch App
- Add the [Webhooks integration](https://app.smooch.io/integrations/webhook) with the following settings:
```
Target: https://mywebsite/api/v1/webhooks/smooch
Trigger: message:appUser
```
- Grab the Webhook's `secret` token
- Add the token as an environment variable in your `.env` file as:
```
SMOOCH_WEBHOOK_SECRET="secret goes here"
```

In order to test the autoresponders in different circumstances, we needed a way to reset our conversation history. We do this through Smooch's [REST API](https://docs.smooch.io/rest/#delete-user-profile) when we receive a message with the special code: `resetmyhistory`

To enable this reset functionality, you'll need credentials for the API:

- Go to your Smooch App
- Go to the Settings tab
- Scroll down to **Secret Keys**
- Create a new key and add the credentials to your `.env` file as:
```
SMOOCH_JWT_ID="key id goes here"
SMOOCH_JWT_SECRET="secret goes here"
```


### Local Server

**Run the Server**
```
cd /path/to/project
heroku local
```

Your app will be running at http://localhost:3333/


### Remote Server

The app is designed to run easily on a Ruby [Heroku](https://www.heroku.com/) instance with the [Postgres add-on](https://www.heroku.com/postgres).

You should be able to connect Heroku to your Github repository and do a [deploy](https://devcenter.heroku.com/articles/getting-started-with-ruby#deploy-the-app).


## Documentation

### API

The purpose of this server is to provide a JSON API for our [Text A Coach](https://github.com/IDEOorg/text-a-coach) web app.

#### Conversations

A `Conversation` is made up of `Messages` which take place between an `Agent` and a `User`

**GET [/api/v1/conversations](http://localhost:3333/api/v1/conversations)**

Returns a list of `Conversations` with metadata.

```
[
  {
    "id": 1,
    "flavor_id": 1,
    "agent_id": 2,
    "user_id": 2,
    "summary_question": "What are my options for having friends/family help with my bills?",
    "summary_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
    "teaser_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
    "last_message_at": "2016-11-08T09:05:12.000Z",
    "agent": {
      "id": 2,
      "name": "Daniel F.",
      "job_title": "CPA"
    },
    "user": {
      "id": 2,
      "name": "Ariela S.",
      "city": "Yonkers",
      "state": "NY"
    }
  },
  ...
}
```

**GET [/api/v1/conversations/:id](http://localhost:3333/api/v1/conversations/1)**

Returns a single `Conversation` with metadata.

```
{
  "id": 1,
  "flavor_id": 1,
  "agent_id": 2,
  "user_id": 2,
  "summary_question": "What are my options for having friends/family help with my bills?",
  "summary_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
  "teaser_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
  "last_message_at": "2016-11-08T09:05:12.000Z",
  "agent": {
    "id": 2,
    "name": "Daniel F.",
    "job_title": "CPA"
  },
  "user": {
    "id": 2,
    "name": "Ariela S.",
    "city": "Yonkers",
    "state": "NY"
  }
}
```

**GET [/api/v1/conversations/search?query=401k](http://localhost:3333/api/v1/conversations/search?query=401k)**

Returns a list of `Conversations` that match the supplied `query`.

```
[
  {
    "id": 1,
    "flavor_id": 1,
    "agent_id": 2,
    "user_id": 2,
    "summary_question": "What are my options for having friends/family help with my bills?",
    "summary_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
    "teaser_answer": "There's several options, from informal to legally binding. We can find one that works for you. ",
    "last_message_at": "2016-11-08T09:05:12.000Z",
    "agent": {
      "id": 2,
      "name": "Daniel F.",
      "job_title": "CPA"
    },
    "user": {
      "id": 2,
      "name": "Ariela S.",
      "city": "Yonkers",
      "state": "NY"
    }
  },
  ...
}
```

#### Messages

`Messages` can be loaded for a given `conversation_id`


**GET [/api/v1/messages/?conversation_id](http://localhost:3333/api/v1/messages/?conversation_id=1)**

```
[
  {
    "id": 48,
    "conversation_id": 1,
    "direction": "direction_in",
    "message": "Thanks, and yes! My employer offers matchings.",
    "created_at": "2017-04-14T05:29:10.232Z"
  },
  {
    "id": 49,
    "conversation_id": 1,
    "direction": "direction_out",
    "message": "Then try to contribute at least enough to get the match. It would be very useful!",
    "created_at": "2017-04-14T05:29:10.234Z"
  },
  {
    "id": 100,
    "conversation_id": 1,
    "direction": "direction_in",
    "message": "How much should I contribute to my 401k?",
    "created_at": "2017-04-14T05:29:10.471Z"
  },
  {
    "id": 101,
    "conversation_id": 1,
    "direction": "direction_out",
    "message": "Saving 10% of your earnings for retirement is the general goal. Does your employer offer matching?",
    "created_at": "2017-04-14T05:29:10.472Z"
  }
]
```


### CMS

We make use of the [Active Admin](https://github.com/activeadmin/activeadmin) gem to give us a lightweight content management system. Locally, you'll be able to access it at http://localhost:3333/admin

You can login with any `AdminUser` account. One should already be set up for you: 
```
User: test@test.com
Pass: test123
```

In this CMS you should be able to administer the `Conversations` that appear on your website.


## About IDEO.ORG

TODO: Who we are

## Questions / Contact

TODO: Where to send questions / concerns.

## License

TODO: Make a selection

© IDEO.ORG 2017
