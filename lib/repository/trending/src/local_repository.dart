import 'package:bloc_test/model/home/trending.dart';
import 'package:bloc_test/repository/trending/trending_repository.dart';
import 'package:time/time.dart';

class TrendingLocalRepository extends TrendingRepository {
  @override
  Future<List<Trending>> getTrendings({int pageNo, int pageSize}) async {
    await Future.delayed(1.seconds);
    return [
      Trending(
          id: '1',
          dateTime: DateTime.now(),
          title: 'local蛋壳公寓跑路啦',
          tags: ['标签1', '标签2']),
      Trending(
          id: '2',
          dateTime: DateTime(2020, 12, 01, 12, 01, 01),
          title: 'local马拉松',
          tags: ['标签1', '标签2']),
      Trending(
          id: '3',
          dateTime: DateTime(2020, 1, 1, 1, 1, 1),
          title: 'local行业峰会',
          tags: ['标签1', '标签2']),
      Trending(
          id: '4',
          dateTime: DateTime.now(),
          title: 'local蛋壳公寓跑路啦',
          tags: ['标签1', '标签2']),
      Trending(
          id: '5',
          dateTime: DateTime(2020, 12, 01, 12, 01, 01),
          title: 'local马拉松',
          tags: ['标签1', '标签2']),
      Trending(
          id: '6',
          dateTime: DateTime(2020, 1, 1, 1, 1, 1),
          title: 'local行业峰会',
          tags: ['标签1', '标签2']),
      Trending(
          id: '7',
          dateTime: DateTime.now(),
          title: 'local蛋壳公寓跑路啦',
          tags: ['标签1', '标签2']),
      Trending(
          id: '8',
          dateTime: DateTime(2020, 12, 01, 12, 01, 01),
          title: 'local马拉松',
          tags: ['标签1', '标签2']),
      Trending(
          id: '9',
          dateTime: DateTime(2020, 1, 1, 1, 1, 1),
          title: 'local行业峰会',
          tags: ['标签1', '标签2']),
    ];
  }
}
