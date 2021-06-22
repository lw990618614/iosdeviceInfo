{
    "attribution": {},
    "device_info": {},
    "final_decision": "Reject",
    "final_score": 130,
    "geoip_info": {},
    "hit_rules": [{
        "decision": "Accept",
        "id": "64446904",
        "name": "注册设备状态异常_高风险",
        "score": 60,
        "uuid": "c64c3c92c4164c658f70ba7f50b59c28"
    }, {
        "decision": "Accept",
        "id": "64446944",
        "name": "越狱识别",
        "score": 10,
        "uuid": "bb51248ba05c429895be261de94e65be"
    }, {
        "decision": "Accept",
        "id": "64446974",
        "name": "注册代理检测",
        "score": 20,
        "uuid": "a2bbad2ca20b4229b7cdd24dffc46d9d"
    }, {
        "decision": "Accept",
        "id": "64447084",
        "name": "7天内设备使用过多信息注册",
        "score": 40,
        "uuid": "15d7daa749774406b0c99057c0ddd553"
    }],
    "policy_name": "注册事件_ios_20210526",
    "policy_set": [{
        "hit_rules": [{
            "decision": "Accept",
            "id": "64446904",
            "name": "注册设备状态异常_高风险",
            "score": 60,
            "uuid": "c64c3c92c4164c658f70ba7f50b59c28"
        }, {
            "decision": "Accept",
            "id": "64446944",
            "name": "越狱识别",
            "score": 10,
            "uuid": "bb51248ba05c429895be261de94e65be"
        }, {
            "decision": "Accept",
            "id": "64446974",
            "name": "注册代理检测",
            "score": 20,
            "uuid": "a2bbad2ca20b4229b7cdd24dffc46d9d"
        }, {
            "decision": "Accept",
            "id": "64447084",
            "name": "7天内设备使用过多信息注册",
            "score": 40,
            "uuid": "15d7daa749774406b0c99057c0ddd553"
        }],
        "policy_decision": "Reject",
        "policy_mode": "Weighted",
        "policy_name": "通用注册_异常注册_ios",
        "policy_score": "130",
        "policy_uuid": "cd1ac035960342c2868a741ef2ac5330",
        "risk_type": "suspiciousRegister"
    }, {
        "hit_rules": [],
        "policy_decision": "Accept",
        "policy_mode": "Weighted",
        "policy_name": "通用注册_风险注册_ios",
        "policy_score": "0",
        "policy_uuid": "58adcfdfcb0748cf9a72bbb5425e9ad7",
        "risk_type": "suspiciousRegister"
    }],
    "policy_set_name": "注册事件_ios_20210526",
    "reason_code": "",
    "risk_type": "suspiciousRegister_reject",
    "seq_id": "1624261394938305S3ACC54974271569",
    "spend_time": 23,
    "success": true
}
