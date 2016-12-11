# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

flavor1 = Flavor.where(name: "Text A Coach").first_or_create
flavor2 = Flavor.where(name: "Trust").first_or_create

agent1 = Agent.where(email: 'mwinkler@ideo.com').first_or_create({ name: 'Matt W.', job_title: "CFP"})
agent2 = Agent.where(email: 'dfeldman@ideo.org').first_or_create({ name: 'Daniel F.', job_title: "CPA"})

user1 = User.where(phone_number: '+18885551111').first_or_create({ name: 'John W.', email: "demo1@test.com", city: "Los Angeles", state: "CA"})
user2 = User.where(phone_number: '+18885551112').first_or_create({ name: 'Frank D.', email: "demo2@test.com", city: "New York", state: "NY"})

flavor1.conversations.where(summary_question: "How much should I contribute to my 401k?").first_or_create({
  user_id: user1.id,
  agent_id: agent1.id,
  summary_answer: "Saving 10%% of your earnings for retirement is the general goal. If your Employer offers matching, try to contribute at least enough to get the match.",
  last_message_at: Date.today - 5.days,
  tag_list: "retirement, 401k, saving"
})

flavor1.conversations.where(summary_question: "How can I get rid of credit card debt?").first_or_create({
  user_id: user2.id,
  agent_id: agent1.id,
  summary_answer: "Pay as much as you can on your highest interest rate card, and pay the minimum on the rest. Once the first is paid off, continue with the next-highest interest rate. Be patient and persistent!",
  last_message_at: Date.today - 4.days,
  tag_list: "debt, credit"
})

flavor1.conversations.where(summary_question: "How do I check my credit score?").first_or_create({
  user_id: user2.id,
  agent_id: agent2.id,
  summary_answer: "Many credit cards offer a free way to check your score on your statement or online. If your card doesn't give you your score, CreditKarma.com is a great free tool to use!",
  last_message_at: Date.today - 3.days,
  tag_list: "credit, score"
})


flavor2.conversations.where(summary_question: "How much should I contribute to my 401k?").first_or_create({
  user_id: user2.id,
  agent_id: agent2.id,
  summary_answer: "Saving 10%% of your earnings for retirement is the general goal. If your Employer offers matching, try to contribute at least enough to get the match.",
  last_message_at: Date.today - 5.days,
  tag_list: "retirement, 401k, saving"
})

AdminUser.where(email: 'textacoach@ideo.com').first_or_create({password: ENV['ADMIN_PASS'] || "demo123", password_confirmation: ENV['ADMIN_PASS'] || "demo123"})
