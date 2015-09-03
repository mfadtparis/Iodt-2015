/*
* Twitter4j send tweet
 */

import processing.serial.*;

static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";
static String AccessToken = "";
static String AccessTokenSecret = "";

ConfigurationBuilder cb;

Twitter twitter;

void setup() {

  size(700, 200);
  background(0);
  smooth();

  cb = new ConfigurationBuilder();

  // These need to be filled in from your twitter application details
  cb.setOAuthConsumerKey(OAuthConsumerKey);
  cb.setOAuthConsumerSecret(OAuthConsumerSecret);
  cb.setOAuthAccessToken(AccessToken);
  cb.setOAuthAccessTokenSecret(AccessTokenSecret);

  twitter = new TwitterFactory(cb.build()).getInstance();
 
}

void draw() {
}

void keyPressed()
{
  println("keyPressed");
  tweet("This is a tweet sent from Processing! :-)" + random(100) + random(200) + random(500));
  //---------------------------------Using random() is to create a unique tweet   each time; Twitter doesn't like back to back same Tweets
}//end keyPressed

void tweet(String theTweet)
{
  try
  {
    Status status = twitter.updateStatus(theTweet);
    System.out.println("Status updated to [" + status.getText() + "].");
  }
  catch (TwitterException te)
  {
    System.out.println("Error: "+ te.getMessage());
  }
  println("tweetSent");
}//end void tweet()

//-------------------------------- 

