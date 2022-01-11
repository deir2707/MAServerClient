import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/repo/repository.dart';

class EchipaRepository extends Repository<Echipa, int> implements IRepository<Echipa, int>
{
  EchipaRepository.initRepo(items):super.initRepo(items);
}