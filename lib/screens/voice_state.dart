
//for shared data to be accessed in other
class VoiceCallState{
  bool isJoined = false; //know whether the other party has oines
  bool openMicrophone = true;
  bool enableSpeaker = true;
  String callTime = "00.00";
  String callStatus = "not connected";

   var to_token = "";
   var to_name = "";
   var to_avatar = "";
   var doc_id = "";
   var call_role = "audience";

}