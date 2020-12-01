import 'package:bloc_test/model/home/trending.dart';

/// Single Source of Truth 真相的唯一来源
/// 
abstract class TrendingRepository {
  Future<List<Trending>> getTrendings({int pageNo, int pageSize});
}
