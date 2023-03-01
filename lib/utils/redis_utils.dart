import 'package:redis_dart/redis_dart.dart';

import 'constants.dart';

/// this class is a util class related to redis affairs
class RedisUtils {
  static RedisClient? _redisClient;

  /// this method is to get a string value from redis
  /// @param key - the key in redis
  /// @return value - value from redis
  static Future<String> getString(String key) async {
    RedisClient client = await _getInstance();
    return (await client.get(key)).toString();
  }

  /// this method is to set a string value into redis
  /// @param key - the key
  ///        value - the value
  static Future<void> setString(String key, String value) async {
    RedisClient client = await _getInstance();
    client.set(key, value);
  }

  static Future<RedisClient> _getInstance() async {
    _redisClient ??=
        await RedisClient.connect(Constants.redisIp, Constants.redisPort);
    return _redisClient!;
  }
}
