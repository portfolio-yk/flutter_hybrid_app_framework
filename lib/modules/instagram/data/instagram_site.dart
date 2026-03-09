enum InstagramSite {
  oauth, accountsLogin, accountsOneTap, prevRedirect, faceBookSite
}
extension InstagramSiteExtension on InstagramSite {
  get value {
    switch(this) {
      case InstagramSite.oauth :
        return "https://www.instagram.com/oauth/authorize?client_id=";
      case InstagramSite.accountsLogin :
        return "https://www.instagram.com/accounts/login/";
      case InstagramSite.accountsOneTap :
        return "https://www.instagram.com/accounts/onetap/";
      case InstagramSite.prevRedirect :
        return "https://l.instagram.com/";
      case InstagramSite.faceBookSite :
        return "https://m.facebook.com/";
    }
  }
}
