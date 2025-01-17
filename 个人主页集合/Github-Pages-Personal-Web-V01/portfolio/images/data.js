var data = [];
var dataStr = '1、国家级大学生创新创业计划<br>\
<br>\
项目负责人：杨博雷、钱奇峰<br>\
指导教师：闵锦忠、殷跃峰<br>\
申报日期：2013年05月01日<br>\
在对流系统的触发机制中，地形的影响是不可忽略的因素。前人的研究表明，地形的动力效应是关键的触发机制之一，而对可能有巨大作用的地形热力因素（尤其是植被的影响）研究不多。本项目旨在通过理论分析和数值试验，揭示中尺度地形热力因素对于对流系统触发的机理，并深入探索地形的热力与动力过程相互作用产生的共同影响。<br>\
<br>\
<br>\
2、SCMREX飑线过程模拟<br>\
<br>\
作者：钱奇峰、林岩銮<br>\
主要内容：对SCMREX期间的一次飑线过程进行云解析分辨率数值模拟，发现飑线的长度与冷池强度相关，更进一步的分析表明，冷池强度与微物理方案中雨蒸发和雹过程紧密相关。<br>\
<br>\
<br>\
3、SBU-YLIN方案的改进<br>\
<br>\
作者：钱奇峰、林岩銮<br>\
主要内容：利用SCMREX期间一次飑线过程的观测资料，对SBU-YLIN方案进行改进，修正了该方案原先冷池模拟偏弱的现象。<br>\
<br>\
<br>\
4、利用神经网络进行短临预报<br>\
<br>\
作者：钱奇峰、李驰钦、苑明理<br>\
主要内容：利用神经网络与雷达外推方法进行短临预报。效果略微优于Convoluition LSTM。<br>\
';
var d = dataStr.split('<br><br><br>');
for (var i = 0; i < d.length; i++) {
    var c = d[i].split('<br><br>');
    data.push({
        img: c[0].replace('、', ' ') + '.jpg',
        caption: c[0].split('、')[1],
        desc: c[1]
    });
    //console.log(c[0].replace('、', ' ') + '.jpg');
};