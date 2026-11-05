import 'package:flutter/material.dart';
import '../data/drinks.dart';
import '../models/drink.dart';
import '../services/drink_picker.dart';
import '../services/favorites_store.dart';
import '../widgets/pop_cup.dart';

const yellow = Color(0xFFFFDB3D), pink = Color(0xFFFF337A), purple = Color(0xFF6C4DFF);
const ink = Color(0xFF21152B);
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final picker = DrinkPicker(), store = FavoritesStore();
  String mood = 'ง่วงมาก', task = 'ปั่นงานด่วน';
  String alcoholMode = 'none';
  int sweetMl = 20;
  Drink? selected;
  Set<String> favorites = {};
  bool caffeineFree = false, rolling = false;
  int tab = 0;
  late final AnimationController bounce;
  @override void initState() {
    super.initState();
    bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _load();
  }
  @override void dispose() { bounce.dispose(); super.dispose(); }
  Future<void> _load() async { final saved = await store.load(); if (mounted) setState(() => favorites = saved); }
  Future<void> _roll() async {
    if (rolling) return;
    setState(() => rolling = true);
    await bounce.forward(from: 0);
    if (!mounted) return;
    setState(() {
      selected = picker.pick(drinks, mood, task, excludeId:selected?.id, caffeineFree:caffeineFree, alcoholMode:alcoholMode);
      tab = 0; rolling = false;
    });
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (mounted) resultKey.currentState?.ensureVisible();
  }
  final GlobalKey<_ResultAnchorState> resultKey = GlobalKey<_ResultAnchorState>();
  Future<void> _toggle(Drink d) async {
    setState(() { if (!favorites.add(d.id)) favorites.remove(d.id); });
    await store.save(favorites);
  }
  Widget _heading(String t) => Padding(padding:const EdgeInsets.only(bottom:12),child:Text(t,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:ink)));
  Widget _option(String label,String emoji,bool active,VoidCallback onTap) => InkWell(
    onTap:onTap,borderRadius:BorderRadius.circular(22),child:AnimatedContainer(duration:const Duration(milliseconds:190),
    padding:const EdgeInsets.symmetric(horizontal:15,vertical:17),
    decoration:BoxDecoration(color:active?const Color(0xFFFFC4DA):Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:active?pink:ink,width:active?3:1.4),boxShadow:active?[const BoxShadow(color:ink,offset:Offset(3,4),blurRadius:0)]:null),
    child:Row(children:[Text(emoji,style:const TextStyle(fontSize:27)),const SizedBox(width:12),Expanded(child:Text(label,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800))),if(active)const Icon(Icons.check_circle,color:pink)])));
  Widget _drinkCard(Drink d) => Container(
    padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:const Color(0xFFFFD5E6),borderRadius:BorderRadius.circular(28),border:Border.all(color:ink,width:2.5),boxShadow:const [BoxShadow(color:ink,offset:Offset(5,6),blurRadius:0)]),
    child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Center(child:PopCup(size:150,color: d.caffeinated ? const Color(0xFFBF8CFF):pink)),
      const SizedBox(height:12),Text(d.name,textAlign:TextAlign.center,style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900,color:ink)),
      Text(d.tagline,textAlign:TextAlign.center,style:const TextStyle(fontSize:16)),
      const SizedBox(height:8),Center(child:Wrap(spacing:6,alignment:WrapAlignment.center,children:[Chip(label:Text(d.alcoholic?'🍸 มีแอลกอฮอล์':'🍹 ไม่มีแอลกอฮอล์')),Chip(label:Text(d.caffeinated?'☕ มีคาเฟอีน':'✨ ไม่มีคาเฟอีน')),Chip(label:Text('หวาน ${sweetMl == 10 ? 'น้อย' : sweetMl == 20 ? 'ปานกลาง' : 'มาก'}'))])),
      const SizedBox(height:8),Text('ส่วนผสมหลัก: Señorita ${d.flavor}',textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.w800,color:purple)),
      const SizedBox(height:12),_heading('🛒 วัตถุดิบ'),...d.ingredients.map((s)=>Padding(padding:const EdgeInsets.only(bottom:5),child:Text('• ${s.replaceAll('{syrup}', sweetMl.toString())}'))),
      const SizedBox(height:14),_heading('🥄 วิธีทำ'),...d.steps.asMap().entries.map((e)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Text('${e.key+1}. ${e.value}'))),
      const SizedBox(height:14),OutlinedButton.icon(onPressed:()=>_toggle(d),icon:Icon(favorites.contains(d.id)?Icons.favorite:Icons.favorite_border),label:Text(favorites.contains(d.id)?'บันทึกแล้ว 💖':'เก็บแก้วนี้ไว้')),
    ]));
  @override Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(backgroundColor:yellow,title:const Text('วันนี้ดื่มไรดี? 🧋',style:TextStyle(fontWeight:FontWeight.w900,color:ink))),
    bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.casino_outlined),label:'สุ่มเมนู'),NavigationDestination(icon:Icon(Icons.favorite_border),label:'เมนูโปรด')]),
    body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:680),child:ListView(padding:const EdgeInsets.fromLTRB(20,20,20,40),children:tab==1?[
      _heading('💖 แก้วโปรดของเรา'),if(favorites.isEmpty)const Padding(padding:EdgeInsets.all(20),child:Text('ยังไม่มีเมนูโปรด ลองสุ่มแล้วกดหัวใจดู!')),
      ...drinks.where((d)=>favorites.contains(d.id)).map((d)=>Padding(padding:const EdgeInsets.only(bottom:20),child:_drinkCard(d))),
    ]:[
      Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:yellow,borderRadius:BorderRadius.circular(30),border:Border.all(color:ink,width:2.5),boxShadow:const [BoxShadow(color:ink,offset:Offset(5,6),blurRadius:0)]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('HEY, OFFICE PEOPLE! ✦',style:TextStyle(fontWeight:FontWeight.w900,color:purple,letterSpacing:1)),
        const SizedBox(height:8),const Text('เช้านี้ดื่มไรดี?',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900,color:ink)),
        const Text('งานจะหนักแค่ไหน แก้วนี้ต้องอร่อย!',style:TextStyle(fontSize:16,fontWeight:FontWeight.w600)),
        Center(child:AnimatedBuilder(animation:bounce,builder:(context,child)=>Transform.rotate(angle:rolling ? bounce.value*6.28318 : 0,child:Transform.scale(scale:1+0.08*(1-(bounce.value-0.5).abs()*2),child:child)),child:const PopCup(size:170))),
      ])),
      const SizedBox(height:28),_heading('01 / ตอนนี้ Mood ไหน?'),
      ...List.generate(moods.length,(i)=>Padding(padding:const EdgeInsets.only(bottom:11),child:_option(moods[i],moodIcons[i],mood==moods[i],()=>setState((){mood=moods[i];selected=null;})))),
      const SizedBox(height:22),_heading('02 / วันนี้ต้องเจออะไร?'),
      ...List.generate(tasks.length,(i)=>Padding(padding:const EdgeInsets.only(bottom:11),child:_option(tasks[i],taskIcons[i],task==tasks[i],()=>setState((){task=tasks[i];selected=null;})))),
      const SizedBox(height:20),_heading('03 / มีแอลกอฮอล์ไหม?'),
      SegmentedButton<String>(segments:const [ButtonSegment(value:'none',label:Text('ไม่มี')),ButtonSegment(value:'yes',label:Text('มี')),ButtonSegment(value:'any',label:Text('อะไรก็ได้'))],selected:{alcoholMode},onSelectionChanged:(v)=>setState((){alcoholMode=v.first;selected=null;})),
      if(alcoholMode!='none')const Padding(padding:EdgeInsets.only(top:8),child:Text('สำหรับผู้ใหญ่ตามกฎหมายเท่านั้น • ไม่ดื่มแล้วขับ • ไม่เหมาะกับเวลาทำงาน',style:TextStyle(fontSize:12,color:Colors.black54))),
      const SizedBox(height:20),_heading('04 / หวานแค่ไหนดี?'),
      SegmentedButton<int>(segments:const [ButtonSegment(value:10,label:Text('น้อย')),ButtonSegment(value:20,label:Text('ปานกลาง')),ButtonSegment(value:30,label:Text('มาก'))],selected:{sweetMl},onSelectionChanged:(v)=>setState((){sweetMl=v.first;})),
      const Padding(padding:EdgeInsets.only(top:6,bottom:12),child:Text('ปริมาณไซรัปเป็นค่าเริ่มต้นสำหรับทดลองสูตร ปรับตามความเข้มข้นจริง',style:TextStyle(fontSize:12,color:Colors.black54))),
      SwitchListTile(contentPadding:EdgeInsets.zero,title:const Text('ขอแบบไม่มีคาเฟอีน',style:TextStyle(fontWeight:FontWeight.bold)),subtitle:const Text('เหมาะกับคนอยากเลี่ยงกาแฟและชา'),value:caffeineFree,onChanged:(v)=>setState((){caffeineFree=v;selected=null;})),
      const SizedBox(height:12),FilledButton.icon(onPressed:rolling?null:_roll,icon:Icon(rolling?Icons.hourglass_top:Icons.casino),label:Text(rolling?'กำลังเลือกแก้วเด็ด...':'สุ่มแก้วให้หน่อย!',style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),style:FilledButton.styleFrom(backgroundColor:pink,foregroundColor:Colors.white,padding:const EdgeInsets.symmetric(vertical:22))),
      if(selected!=null)...[const SizedBox(height:28),_ResultAnchor(key:resultKey),_heading('🎉 แก้วของวันนี้!'),_drinkCard(selected!),const SizedBox(height:16),OutlinedButton.icon(onPressed:rolling?null:_roll,icon:const Icon(Icons.refresh),label:const Text('สุ่มใหม่อีกแก้ว'))],
      const SizedBox(height:28),Text('รวม ${drinks.length} สูตรต้นแบบ Señorita (50 ไม่มีแอลกอฮอล์ / 30 มีแอลกอฮอล์) • ปรับสูตรก่อนใช้งานจริง',style:const TextStyle(fontSize:12,color:Colors.black54)),
      const Text('สูตรต้นแบบ ไม่ใช่สูตรทางการของ Señorita • โปรดตรวจสอบวัตถุดิบและอายุผู้ดื่ม',style:TextStyle(fontSize:12,color:Colors.black54)),
    ])))));
}
class _ResultAnchor extends StatefulWidget {
  const _ResultAnchor({super.key});
  @override State<_ResultAnchor> createState() => _ResultAnchorState();
}
class _ResultAnchorState extends State<_ResultAnchor> {
  void ensureVisible() => Scrollable.ensureVisible(context,duration:const Duration(milliseconds:400),curve:Curves.easeOut);
  @override Widget build(BuildContext context) => const SizedBox(height:1);
}
