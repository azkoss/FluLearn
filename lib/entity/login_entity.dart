class LoginEntity {
	String role;
	String uuid;
	String token;

	LoginEntity({this.role, this.uuid, this.token});

	LoginEntity.fromJson(Map<String, dynamic> json) {
		role = json['role'];
		uuid = json['uuid'];
		token = json['token'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['role'] = this.role;
		data['uuid'] = this.uuid;
		data['token'] = this.token;
		return data;
	}
}
