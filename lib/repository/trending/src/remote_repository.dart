import 'package:bloc_test/api/trending_api.dart';
import 'package:bloc_test/model/home/trending.dart';
import 'package:bloc_test/repository/trending/trending_repository.dart';

class TrendingRemoteRepository extends TrendingRepository {
  final TrendingApi trendingApi;
  TrendingRemoteRepository() : trendingApi = TrendingApi.getInstance();
  @override
  Future<List<Trending>> getTrendings({int pageNo, int pageSize}) async {
    return trendingApi.getTrendings(pageNo: pageNo, pageSize: pageSize);
  }
}
