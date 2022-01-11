import 'package:flutter_proj/model/meci.dart';
import 'package:flutter_proj/repo/repository.dart';

class MeciRepository extends Repository<Meci, int> implements IRepository<Meci, int>
{
  MeciRepository.initRepo(items):super.initRepo(items);
}