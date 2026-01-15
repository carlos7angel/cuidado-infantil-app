import 'package:cuidado_infantil/Child/models/child.dart';
import 'package:cuidado_infantil/Child/services/child_service.dart';
import 'package:cuidado_infantil/Config/models/response_request.dart';

class ChildRepository {

  Future<ResponseRequest> getChildById({required String childId}) async => await ChildService().getChildById(childId: childId);
  
  Future<ResponseRequest> createChild({required Child child}) async => await ChildService().createChild(child: child);

  Future<ResponseRequest> updateChild({required Child child, Map<String, List<dynamic>?>? originalFiles}) async => await ChildService().updateChild(child: child, originalFiles: originalFiles);

  Future<ResponseRequest> getChildrenByChildcareCenter({required String childcareCenterId}) async => await ChildService().getChildrenByChildcareCenter(childcareCenterId: childcareCenterId);

}