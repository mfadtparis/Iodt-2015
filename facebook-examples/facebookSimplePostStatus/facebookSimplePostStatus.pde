/*
* Uses facebook4j: http://facebook4j.org/en/code-examples.html#post_message
*/

Facebook facebook = new FacebookFactory().getInstance();

String appId = "";
String appSecret = "";
String accessToken = "";

facebook.setOAuthAppId(appId, appSecret);
facebook.setOAuthPermissions("publish-stream");
facebook.setOAuthAccessToken(new AccessToken( accessToken,null ));


try {
  facebook.postStatusMessage(":-) Hello from p5 "+random(1000));
}catch (FacebookException te) {
  println("Couldn't connect: " + te);
}
