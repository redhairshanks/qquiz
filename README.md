# README

## Tech stack used
* Ruby on Rails, Postgres, Redis

## Backend Considerations
* Used redis to store sessions which expire after 3 hours
* Also used redis to store the shareable link id which expires after 7 days
* Currently hosted on AWS with both postgres and redis on single EC2 machine to complexity
* Have put in controller level and database level validations wherever necessary


## Database Design

![Database Design](https://kroki.io/dbml/svg/eNqlk0tuwyAQhvc-BSfwAbrwIars0QQm6VS8CriJVPXuBTuOMXbUKN4x729-4ABHhawP6AP7aRgjyfqeZDoZ0Mi-wYsP8MlEDaQK20EIF-sll3TGEIuI8AgRJYfIIukUA-2Su3dy7f5tmsNA4KxS_xDkKq5IU-RkeEBhjQyMTMQz5nhegs_VL2Pwrz65yZqaZwjO5pTGI17L_Z1NTCXYSyT37mDCZX07C9ACyikQqNFkjSReC4qxTw1L4TaAHa1VCGaXcg58JEEOsgBL4Op2Ki1TMx95brsYiUaunScyoHgQ1uNekQeobYG3eDf0noo_g83S7aR6x9Pb-BXaaX43fs42TbtH5xfaTjp2t7IprX4-7WqBrm61mFDe5MMh68xH1KXQzyU9xfsHSxCwxA== "a title")


## Considerations


## API testing workflow

### Create user and sign-in


* First create user with name and email. Email is unique. 
  * API - user/create
* Sign-in with newly created user to obtain the session id which will be passed in header as x-session-id for authentication
  * API - user/sign-in

### Create poll and questions

* Create poll with name and time_limit_in_seconds. Currently time_limit_in_seconds is just taken but not implemented
  * API - poll/create
* Create questions with their answer options. Every question must have options. Options have a text field along with is_answer boolean. Questions also have a points field for that question. 
  * API - poll/question/create


### Answer poll

* Every poll needs to be started before answering the questions present in the poll
  * API - poll/start
* Questions are answered with list of option_ids
  * API - poll/question/answer/create
* All questions can be re-answered until and unless user ends the poll. Poll ending also calculates the final score of user in that poll
  * API - poll/end

### Show poll and poll participants
* Poll can be fetched to get view of all questions and the options within them
  * API - poll/:poll_id
* Poll participants lists all the users who have participated in the poll and their final_scores
  * API - poll/participants

### Share Poll
* Polls can be shared using share poll feature. You get a unique url for that poll
  * API - poll/share
  * Outputs - poll/link/:link_id
* Shared link currently gives out the actual url. If a WebUX component was present a redirection will be better. 
  * API - poll/link/:link_id
 
 
## Future Considerations/ Not considered for current release
* While redis is present, caching of data is not done. Like quiz, questions, options can be cached to avoid db i/o's
* Anonymous users cannot participate in quiz and have to create user
* User level permissions like quiz_creator, quiz_participant is not present
* Question other than multiple choice questions can be put in
* Time bound quiz, quiz start_time can be made changeable
* Multiple contributors for a quiz
* Final score of candidates can be calculated using background jobs 
