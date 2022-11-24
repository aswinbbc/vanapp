class EmployeeModel {
  String? empId;
  String? empCode;
  String? empName;
  String? nationality;
  String? levelId;
  String? salary;
  String? departmentId;
  String? designationId;
  String? categoryId;
  String? doj;
  String? empImage;
  String? isActive;
  String? clientId;
  String? departmentId1;

  EmployeeModel(
      {this.empId,
      this.empCode,
      this.empName,
      this.nationality,
      this.levelId,
      this.salary,
      this.departmentId,
      this.designationId,
      this.categoryId,
      this.doj,
      this.empImage,
      this.isActive,
      this.clientId,
      this.departmentId1});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empCode = json['emp_code'];
    empName = json['emp_name'];
    nationality = json['nationality'];
    levelId = json['level_id'];
    salary = json['salary'];
    departmentId = json['department_id'];
    designationId = json['designation_id'];
    categoryId = json['category_id'];
    doj = json['doj'];
    empImage = json['emp_image'];
    isActive = json['isActive'];
    clientId = json['client_id'];
    departmentId1 = json['department_id1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_id'] = empId;
    data['emp_code'] = empCode;
    data['emp_name'] = empName;
    data['nationality'] = nationality;
    data['level_id'] = levelId;
    data['salary'] = salary;
    data['department_id'] = departmentId;
    data['designation_id'] = designationId;
    data['category_id'] = categoryId;
    data['doj'] = doj;
    data['emp_image'] = empImage;
    data['isActive'] = isActive;
    data['client_id'] = clientId;
    data['department_id1'] = departmentId1;
    return data;
  }
}
