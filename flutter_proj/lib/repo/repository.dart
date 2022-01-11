import 'package:flutter_proj/model/entity.dart';

abstract class IRepository<T extends Entity<ID>, ID> {
  void add(T elem);
  void delete(ID id);
  void update(T elem);
  T getOne(ID id);
  List getAll();
  void destroyList();
}

class Repository<T extends Entity<ID>, ID> implements IRepository<T, ID> {
  late List<T> items;
  Repository() {
    items = [];
  }
  Repository.initRepo(this.items);

  @override
  void add(elem) {
    items.add(elem);
  }

  @override
  void delete(id) {
    items.removeWhere((element) => element.id == id);
  }

  @override
  List<T> getAll() {
    return items;
  }

  @override
  getOne(id) {
    return items.where((element) => element.id == id).first;
  }

  @override
  void update(elem) {
    var index = items.indexWhere((element) => element.id == elem.id);
    print(index.toString());
    items[index] = elem;
  }

  @override
  void destroyList() {
    items.clear();
  }
}
