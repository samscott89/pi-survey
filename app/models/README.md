Models
======
------


This page gives an overview of the models (similar to classes) used in the application.

However, to make sense of the models, a schematic of how the system interacts is essential.

The following shows an overview of the models (equivalently, the databases) used in the application.

<img src="/erd-4ad952244e7e0a18872545b6028da14d3ceadab9.png">

There are a few main structures: the Survey hierarchy, Users, and Campaigns. Survey is the most significant of these.

As an overview: a Survey contains a number of SurveySections, each of which has a number of Questions. A Question is linked to the possible choices (OptionChoices) via the group OptionGroup. Each set of choices for a question is grouped as one, and has a single type (QuestionType).

Each response to a question is modelled as an Answer, which captures multiple answers through AnswerOption. Answers are also associated to a User. ActiveSurveys capture the state of a user currently answering a Survey.

Users are generally handled by the [Devise gem](https://github.com/plataformatec/devise/).

Campaigns are used to group Surveys from the survey-creator perspective. Each Survey can be associated with multiple campaigns, and campaigns are owned by Users.


------


Survey
------

The Survey model is the main wrapper class for the a survey/questionnaire. The actual Question objects are contained in SurveySections, which are indexed within the Survey model. Therefore, the Survey model contains the meta parameters of the survey, such as description, instructions and similar.

The Survey model (table name: surveys) has the following columns: 

| Field | Type | Description |
|---|---|---|
|**name** | string | Contains the name of the survey (aka the title). |
|**instructions** | text | The preamble for the survey. |
|**description** | text | A brief description of the survey. |
|**is_public** | boolean | A flag to set for whether the survey shows up in user lists. |

Surveys have multiple SurveySections, which are linked by the section_id field in SurveySection.

TODO: 
  * Survey tags (i.e. descriptive tags for each survey). The databases are configured for survey tags, but they are currently not implemented anywhere.
 

SurveySection
------

A SurveySection is a component of a survey which contains a subset of the questions for the whole survey. These can typically be thought of as different pages of a survey. Technically, there is no reason why a survey cannot consist of a single section with a big list of questions, however this is unlikely to be the best way to display to a user.

The SurveySection model (table name: survey_sections) has the following columns: 

| Field | Type | Description |
|---|---|---|
|**name** | string | Used for internal reference. |
|**title** | string | The title of the section. |
|**subtitle** | string | The text following the section title. |
|**required** | boolean | Whether the section is compulsory. |
|**survey_id** | integer | The ID of the parent survey. |
|**idx** | integer | The index/placement of the section within the survey. |

Note that a SurveySection is essentially defined by the pair (survey_id, index) which tells you which survey it belongs to, and where in the survey it appears. In fact, the resource path for a survey section is given by `survey_section_path(survey_id, index)`.

A SurveySection also has many Questions.

The name field is primarily used as a way for the survey creator to track the section. This will usually simply be the section title or a generic name 'Section 1'.
  

Question
------

The Question model (table name: questions) has the following columns: 

| Field | Type | Description |
|---|---|---|
|**name** | string | Used for internal reference. |
|**subtext** | string | The question text. |
|**required** | boolean | Whether the question is compulsory. |
|**allow_other** | boolean | Whether the question permits other user-input answers (for multiple choice questions). |


QuestionType
------

In Rails, there are various question types used by form helpers (see: [Form Helpers](http://guides.rubyonrails.org/form_helpers.html)). Each of these corresponds to a type of input which can be used in a form. Therefore, when the survey needs to be rendered, the question type is essential to tell the app what type of question to show. This is encapsulated by these elements.

The QuestionType model (tablename: question_types) has the following columns: 

| Field | Type | Description |
|---|---|---|
|**name** | string | The question type. |
   


OptionGroup
------

OptionGroup works as a container for the possible choices of a question.

| Field | Type | Description |
|---|---|---|
|**name** | string | The name for the option group. |
|**type_id** | integer | The question type for the group. |
|**question_id** | integer | The question. |
  
OptionGroup has a convenient function `option_group.deep_copy` which can be used to create a new OptionGroup with the same choices.

OptionChoice
------

The OptionChoice model corresponds to possible answer options for a question. These are grouped together by a common OptionGroup.

| Field | Type | Description |
|---|---|---|
|**choice_name** | string | The text for the answer option. |
|**option_group_id** | integer | The option group the option belongs to. |

The **choice_name** is also commonly used as the answer value.


Answer
------

The Answer model corresponds to responses by a user for a particular question. Hence an Answer forms a relationship between a User and a Question. This is further expanded out with AnswerOptions linked to OptionChoices.
    

User
------

The user model encapsulates the user details and preferences. It is also linked to Answers for organising results.

Most of the details of these fields can be found in the  [Devise](https://github.com/plataformatec/devise/) documentation.

  

Campaign
--------

**TODO**: fill in information.

  
  
Miscellaneous
-------------

Many models have a **deleted** field. This is used to soft-delete records without actually removing from the database. This is to help recover data in the case of accidental deletes, or when a user wishes to recover data. 