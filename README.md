# halp-slack
Get Stack Exchange answers in Slack

![example image 1](http://i.imgur.com/Tvhnsxk.png)

Powered by the [Stack Exchange API](https://api.stackexchange.com/)

### What you will need
* A [Heroku](http://www.heroku.com) account
* An [outgoing webhook token](https://api.slack.com/outgoing-webhooks) for your Slack team

### Setup
* Clone this repository locally
* Create a new Heroku app
* Push the repository to Heroku
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your outgoing webhook integration in Slack
  * ```BOT_USERNAME``` The name the bot will use when posting to Slack
  * ```BOT_ICON``` The emoji icon for the bot (I used the tophat emoji)
  * ```SLACK_CHANNEL``` The ID for the slack channel where Halp will live 
  * ```SLACK_API_TOKEN``` A personal API token with access to the slack channel
  * ```STACK_EXCHANGE_SITE``` The site parameter (typically ```stackoverflow```)

* Navigate to the integrations page for your Slack team. Create an outgoing webhook, choose a trigger word (ex: "halp"), use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable.
