Controllers
=======
-------
   

app/controllers
---------------

This folder contains some of the key logic of the Model-View-Controller (MVC) structure of the website.

A controller is responsible for handling certain requests for resources (the existence of which is specified in [routes.rb](code:routes)).

In the MVC model, a particular resource (or model) will have various associated actions. Each of these will be processed by the controller, and finally displayed by the view.

For each resource /app/models/model.rb , there is a corresponding controller file called /app/controllers/models_controller.rb. These files contain the methods which determine how the server responds to various queries.

In general, the best practice for controllers is to use [strong parameters](http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html), and these can be seen in many of the `model_params` methods.

The controller files used in the application are:

  
Questions Controller
-------
###/app/controllers/questions_controller

Handle creating, updating and destroying questions.
These actions are always reached indirectly - through the edit_surveys page.  


Static Pages Controller
----------
### /app/controllers/static_pages_controller

Static pages have no interaction by definition. Therefore these controllers are empty since there is no action to perform. However,the controller needs to exist so that Rails is able to display the views.
    
The exception to this is currently the `tour` action, which is used to log in a guest user for a simple introduction. 

SurveySections Controller
-----------
### /app/controllers/survey_sections_controller

Everything to do with survey sections.

New, update and delete are used for creating and editing the survey page, and is also accessed from the edit_survey page.

`show` is where the survey page is displayed.

`answer` deals with the form response from a submitted answer.

    
Surveys Controller
----------
### /app/controllers/surveys_controller

Since most of the actual survey logic is handled by section, the surveys controller becomes more of a wrapper. 

The actions used are:
  * show - display the start page of a survey.
  * index - used for displaying a list of surveys.
  * finish - when a user has completed the whole survey.
  * new - initialises a new survey (without sections).
  * create - the action to create and save the new survey.
  * edit - the action for displaying the edit survey page.
  * stats - displays information about the survey responses.
    

Users Controller
---------
### /app/controllers/users_controller

This handles actions for user accounts. However, this is mostly now done by Devise.

Instead, this has a few custom actions. For example, the save/review_surveys pages are used when a guest user logs in.

Campaigns Controller
---------
### /app/controllers/campaigns_controller

Is a straightforward controller used for creating/editing/displaying campaigns.