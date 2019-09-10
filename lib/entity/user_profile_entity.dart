class UserProfileEntity {
	String role;
	String rolename;
	String registerIp;
	UserProfileModelExtInfo extInfo;
	String uuid;
	String registerTime;
	String username;

	UserProfileEntity({this.role, this.rolename, this.registerIp, this.extInfo, this.uuid, this.registerTime, this.username});

	UserProfileEntity.fromJson(Map<String, dynamic> json) {
		role = json['role'];
		rolename = json['rolename'];
		registerIp = json['register_ip'];
		extInfo = json['ext_info'] != null ? new UserProfileModelExtInfo.fromJson(json['ext_info']) : null;
		uuid = json['uuid'];
		registerTime = json['register_time'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['role'] = this.role;
		data['rolename'] = this.rolename;
		data['register_ip'] = this.registerIp;
		if (this.extInfo != null) {
      data['ext_info'] = this.extInfo.toJson();
    }
		data['uuid'] = this.uuid;
		data['register_time'] = this.registerTime;
		data['username'] = this.username;
		return data;
	}
}

class UserProfileModelExtInfo {
	String yesapiAvatar;

	UserProfileModelExtInfo({this.yesapiAvatar});

	UserProfileModelExtInfo.fromJson(Map<String, dynamic> json) {
		yesapiAvatar = json['yesapi_avatar'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['yesapi_avatar'] = this.yesapiAvatar;
		return data;
	}
}
