/*
* Simple twitter4j example based on tutorial by jer thorp:
* http://blog.blprnt.com/blog/blprnt/updated-quick-tutorial-processing-twitter
*/

ConfigurationBuilder cb;
Twitter twitter;
Query query;

ArrayList<String> words = new ArrayList();

void setup() {

  size(550, 550);
  background(0);
  smooth();

  cb = new ConfigurationBuilder();
  
  // These need to be filled in from your twitter application details
  cb.setOAuthConsumerKey("");
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  twitter = new TwitterFactory(cb.build()).getInstance();

  // change this query string to anything you want
  query = new Query("#blacklivesmatter");
  
  query.setCount(20);

  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();

    for (Status tw : tweets) {       
      String msg = tw.getText();       
      println("tweet : " + msg);
      String[] input = msg.split(" ");
      for (int j = 0;  j < input.length; j++) {
       //Put each word into the words ArrayList
       words.add(input[j]);
      }
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  };
}

void draw() {
  fill(0, 1);
  rect(0, 0, width, height);

  //Draw a word from the list of words that we've built
  int i = (frameCount % allTweets.size());
  String word = words.get(i);

  //Put it somewhere random on the stage, with a random size and colour
  fill(255, random(50, 150));
  textSize(random(10, 30));
  text(word, random(width), random(height));
}

