

const String kBaseUrl ="http://ec2-18-224-20-223.us-east-2.compute.amazonaws.com"; 
// "https://fundpeck.fly.dev/api/v1";


// const String kGoogleApiKey = "AIzaSyDDG9vbTjy9bmYNRZjiJqCGiGBpXAkDzwI"; 
const String kGoogleApiKey = "AIzaSyDAkLoOaKCdB6gn_C4CRJ8G9jKJu5X9foQ";


const newApiKey = "AIzaSyDDG9vbTjy9bmYNRZjiJqCGiGBpXAkDzwI";

//  "AIzaSyC2FuBWrtkaM3sjZmZ2xRJsPCQZD6bAjAA";
const fcmKey = 'AAAA8hfeYZKXDOOmZ6OR8Cd70oZdKsD2Ao44YfuXBFgocNOH5gp2'; //replace with your Fcm key
const callsCollection = 'Calls';
const userCollection = 'Users';
const tokensCollection = 'Tokens';
const requestCollection = "Request";
const activeEmergency = "activeEmergency";
const responders ="responders";



//"AIzaSyCcGeOs6pbNgrCSvMarV34r0Oit6eEewtw";

// hardedCoded Salt
const kSalt = "salt_for_encoding";
const logo = "assets/images/logo.png";
const getstartedImage = "assets/images/getstarted.png";



const IMAGEPLACEHOLDER = "https://avatar.iran.liara.run/public";

const int callDurationInSec = 45;

//Agora
const agoraAppId = 'e98134d8f471480d89497c28be439636'; //replace with your agora app id
const agoraTestChannelName = 'EmergencyCall'; //replace with your agora channel name
// const appCert = "47006e53f9d64075a4a20fd6a04a00c0";
const agoraTestToken = '007eJxTYDivbfChO0j4UcLmCc1aoQ6lp5Y3XpUvbGTp0tsswx/N2afAkGppYWhskmKRZmJuaGJhkGJhaWJpnmxkkZRqYmxpZmz247NhekMgI4OnuyojIwMEgvi8DK65qUXpqXnJlc6JOTkMDACypB/o'; //replace with your agora token



//Call Status
enum CallStatus {
  none,
  ringing,
  accept,
  reject,
  unAnswer,
  cancel,
  end,
}



