// if(Unique Key at myHome.dart in not available){

// When app start for first time
// If we wait or sometime(10s to 15s) then if Ads Appear before permission provided then it show render problem

// When app start -> Permission given and left for some time (i.e until ads refresh)
// make sure DataBackup files are not created before
// As ad refresh, it show render problem
// ------------ It seems solved by adding storage permission check before sync start on 20s

// }else{
//  ** Additional issue arises
//   As app launch, it may show ads error because other ads load and set refresh
// }

// 2.

// Issue arise suring update pop up
// Reason - as the pop up came , another banner ads loaded and refreshed the page on back side.
// As of Now, I'm leaving it because it may show users that Update now or It can cause some issue