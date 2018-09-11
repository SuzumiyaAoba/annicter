class Work {
  final int id;
  final String title;
  final String titleKana;
  final String media;
  final String mediaText;
  final String seasonName;
  final String seasonNameText;
  final String releasedOn;
  final String releasedOnAbout;
  final String officialSiteUrl;
  final String wikipediaUrl;
  final String twitterUsername;
  final String twitterHashtag;
  final int malAnimeId;
  final Images images;
  final int episodesCount;
  final int watchersCount;
  final int reviewsCount;
  final bool noEpisodes;

  Work({
    this.id,
    this.title,
    this.titleKana,
    this.media,
    this.mediaText,
    this.seasonName,
    this.seasonNameText,
    this.releasedOn,
    this.releasedOnAbout,
    this.officialSiteUrl,
    this.wikipediaUrl,
    this.twitterUsername,
    this.twitterHashtag,
    this.malAnimeId,
    this.images,
    this.episodesCount,
    this.watchersCount,
    this.reviewsCount,
    this.noEpisodes
  });

  factory Work.fromJson(Map<String, dynamic> jsonStr) {
    if (jsonStr == null) {
      return null;
    }
    return Work(id: jsonStr['id'],
      title: jsonStr['title'],
      titleKana: jsonStr['title_kana'],
      media: jsonStr['media'],
      mediaText: jsonStr['media_text'],
      seasonName: jsonStr['season_name'],
      seasonNameText: jsonStr['season_name_text'],
      releasedOn: jsonStr['released_on'],
      releasedOnAbout: jsonStr['released_on_about'],
      officialSiteUrl: jsonStr['official_site_url'],
      wikipediaUrl: jsonStr['wikipedia_url'],
      twitterUsername: jsonStr['twitter_username'],
      twitterHashtag: jsonStr['twitter_hashtag'],
      malAnimeId: int.tryParse(jsonStr['mal_anime_id']) ?? -1,
      images: Images.fromJson(jsonStr['images']),
      episodesCount: jsonStr['episodes_count'],
      watchersCount: jsonStr['watchers_count'],
      reviewsCount: jsonStr['reviews_count'],
      noEpisodes: jsonStr['no_episodes']);
  }
}

class Images {
  final Facebook facebook;
  final Twitter twitter;
  final String recommendedUrl;

  Images({
    this.facebook,
    this.twitter,
    this.recommendedUrl
  });

  factory Images.fromJson(Map<String, dynamic> jsonStr) {
    return Images(
        facebook: Facebook.fromJson(jsonStr['facebook']),
        twitter: Twitter.fromJson(jsonStr['twitter']),
        recommendedUrl: jsonStr['recommended_url']
    );
  }
}

class Facebook {
  final String ogImageUrl;

  Facebook({this.ogImageUrl});

  factory Facebook.fromJson(Map<String, dynamic> jsonStr) {
    return Facebook(ogImageUrl: jsonStr['og_image_url']);
  }
}

class Twitter {
  final String miniAvatarUrl;
  final String normalAvatarUrl;
  final String biggerAvatarUrl;
  final String originalAvatarUrl;
  final String imageUrl;

  Twitter({
    this.miniAvatarUrl,
    this.normalAvatarUrl,
    this.biggerAvatarUrl,
    this.originalAvatarUrl,
    this.imageUrl
  });

  factory Twitter.fromJson(Map<String, dynamic> jsonStr) {
    return Twitter(
        miniAvatarUrl: jsonStr['mini_avatar_url'],
        normalAvatarUrl: jsonStr['normal_avatar_url'],
        biggerAvatarUrl: jsonStr['bigger_avatar_url'],
        originalAvatarUrl: jsonStr['original_avatar_url'],
        imageUrl: jsonStr['image_url']
    );
  }


}