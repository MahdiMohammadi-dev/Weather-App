import 'package:flutter_test/flutter_test.dart';
import 'package:weatherclean/core/utils/date_converter.dart';

void main(){
  
  test('test the method time format', (){
    
    var result = DateConverter.changeDtToDateTime(1660127867);
    expect(result, "Aug 10");
    
  });
  
}