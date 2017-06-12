# Text A Coach API

Text A Coach is a tool provided by the Steps team at IDEO.org. It is part of a larger effort to design and build digital tools that can empower low-income communities in the U.S. to improve their financial futures. Read more about Steps at https://steps.ideo.org.

Text A Coach allows you to:

* Receive SMS and Facebook messages from users and reply from a web portal
* Provide a website that lets you show examples from the conversations you've had (screened for privacy information)

This repository contains the code for the backend of the service website. You do not need this code to simply receive and respond to messages, though instructions for that are included below. This project builds on that functionality and adds an API to pull past conversations from the database to populate your website, an auto response that is sent to users after their first text, and support for metrics to let you measure usage.

The frontend website template that compliments this project can be found at https://github.com/IDEOorg/text-a-coach-api

We built three example brands to show how Text A Coach can be used:

* [www.inthe99.com](http://www.inthe99.com)
* [www.thedoublecheck.org](http://www.thedoublecheck.org)
* [www.pocketsquad.org](http://www.pocketsquad.org)

## How Messages Flow Through the Involved Services

In order to receive and respond to messages a few services are involved. Setting up these services doesn't actually involve any code.

Here are how real time SMS conversations flow:
User's phone <-----> Twilio <----> Smooch.io <-----> This backend, Zendesk and Slack

A facebook Messenger conversation is similar:
Facebook Messenger <----> Smooch.io <-----> This backend, Zendesk and Slack

Here is how data flows to the website
Active Admin CMS ----> a Postgres SQL database ----> This backend ----> The frontend website

We would like to automatically populate the CMS and database as users text, but that work has not been done.

### The role of each service and how to set it up

#### Twilio
Twilio (twilio.com) lets you register a phone number to use for receiving and sending messages. They are an interface between the carriers and code of your choosing. Discounts are available for non-profits.

Visit their website and:

- Create an account
- Create a [new phone number](https://www.twilio.com/console/phone-numbers/getting-started)

#### Zendesk

Zendesk is a customer support portal. Companies usually use it to answer support requests from users about their product or service. Rather than re-implement a competitor ourselves we recommend it as a fully featured interface for conversing with users of your Text A Coach service. It lets you peruse all past conversations, triage them to difference coaches, and store common answers, among many other features. 

You could use another customer support portal in place of Zendesk, or build your own. 

Visit their website and:

- Create an account
- Choose a custom domain (https://my-domain.zendesk.com)


#### Smooch

While we could have our code work with Twilio directly, Smooch (www.smooch.io) makes it very easy to connect common message platforms with any service you'd like to answer those messages from. This can be done without code. You can receive messages from SMS and Facebook, as well as Twitter and WhatsApp. You can receieve them in popular platforms like Zendesk, Help Scout or even reply from Slack. 

Visit their website and:

- Create an account
- Create a new App
- Add the [Twilio SMS integration](https://app.smooch.io/integrations/twilio) and follow their steps for configuration
- Add the [Zendesk integration](https://app.smooch.io/integrations/zendesk) and follow their steps for configuration

#### At this point you can test receiving and replying to messages

Congratulations! At this stage you should be able to send an SMS to your Twilio phone number, which should automatically create a Zendesk support ticket. Replies to the Zendesk support ticket will be sent back as an SMS!

#### Active Admin CMS

This is a web interface that lets you edit the messages and conversations that you want to appear on your website. 

## Getting the Code Set Up

The code in this repository is not in the SMS to Zendesk pipeline. It does allow you to have an auto-reply if someone texts you for the first time, or the first time in a while. It's main functionality is to provide the conversation data if you choose to show it on a website.

### Local Setup

**Requirements**

To get started, you will need to have the tools installed on your development machine:

- [Ruby 2.3](https://www.ruby-lang.org/en/)
- [PostgreSQL 9.4](https://www.postgresql.org/)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

**Get the Repository and Install Dependencies **
```
git clone https://github.com/IDEOorg/text-a-coach-api.git
cd text-a-coach-api
bundle install
bundle exec rake db:setup
```

**Environment Variables**

The environment file contains all the keys and passwords that this backend needs to connect to the other services. Copy `/.env.example` into your project as `/.env` and change the values to your keys. 

If you want to enbale auto-responders you'll need to get your Smooch Secret Key and include it in this file. The steps are:

- Go to your Smooch App
- Go to the Settings tab
- Scroll down to **Secret Keys**
- Create a new key and add the credentials to your `.env` file as:
```
SMOOCH_JWT_ID="key id goes here"
SMOOCH_JWT_SECRET="secret goes here"
```


#### Enabling Automatic Responses

You can add an optional webhook from Smooch to our API which will enable autoresponders. These were set up to send automated "welcome" and "after hours" text messages to our participants.

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

Remember to include your Smooch secret key in your environment file. Instructions on where to find it are above. 

### Local Server

**Run the Server**

To run this service on your development machine:

```
cd text-a-coach-api
heroku local
```

Your app will be running at http://localhost:3333

Note that page is blank because this is the backend, but you can visit:
The CMS at http://localhost:3333/admin
Or try the API at http://localhost:3333/api/v1/conversations

### Hosting this Service

The app is designed to run easily on a Ruby [Heroku](https://www.heroku.com/) instance with the [Postgres add-on](https://www.heroku.com/postgres).

You should be able to connect Heroku to your Github repository and do a [deploy](https://devcenter.heroku.com/articles/getting-started-with-ruby#deploy-the-app).


## Documentation

### API

This server provides a JSON API for our [Text A Coach](https://github.com/IDEOorg/text-a-coach) web app.

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


### Contribution and Submitting Bugs

We welcome all contributions to this code base, as well as bug reports. To suggest a contribution please open a pull request against this repository. It is likely a good idea to get in touch before doing any work so we can coordinate. 

Please submit any bug reports via Github issues. Click on the Issues tab at the top of this page. 

## About IDEO.ORG

IDEO.org uses human-centered design to create products, services, and experiences that improve the lives of people living in poverty.

We’re mission-driven designers who are looking to have as much impact as possible in the lives of the poor. It starts with getting to know the people we’re designing for. Without them, we wouldn’t know what to design, how it should work, or why it matters. From there we build, test, and iterate until we get it right. 

To learn more please visit www.ideo.org

## Questions / Contact

To get in touch with us please use the form at https://steps.ideo.org/about/ and we'll get back to you quickly. 


© IDEO.ORG 2017
