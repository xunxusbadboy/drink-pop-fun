import '../models/drink.dart';

const moods = ['สดใส', 'ง่วงมาก', 'เครียด', 'เบื่อโลก', 'อยากฮีลใจ'];
const moodIcons = ['😎', '😴', '😵‍💫', '😑', '🥰'];
const tasks = ['ประชุมทั้งวัน', 'ปั่นงานด่วน', 'เคลียร์งาน', 'พบผู้บริหาร', 'วันชิลๆ'];
const taskIcons = ['👥', '💻', '📋', '👔', '☕'];

class _Flavor {
  final String en, th, emoji;
  const _Flavor(this.en, this.th, this.emoji);
}
const _flavors = <_Flavor>[
  _Flavor('Strawberry', 'สตรอว์เบอร์รี', '🍓'),
  _Flavor('White Chocolate', 'ไวท์ช็อกโกแลต', '🍫'),
  _Flavor('Classic Caramel', 'คลาสสิกคาราเมล', '🍮'),
  _Flavor('Freshy Mint', 'เฟรชชี่มินต์', '🌿'),
  _Flavor('Calamansi', 'คาลามันซี', '🍋'),
  _Flavor('Vanilla', 'วานิลลา', '🥛'),
  _Flavor('Green Apple', 'แอปเปิลเขียว', '🍏'),
  _Flavor('Japanese Melon', 'เมลอนญี่ปุ่น', '🍈'),
  _Flavor('Nam Hom Coconut', 'มะพร้าวน้ำหอม', '🥥'),
  _Flavor('Passionfruit', 'เสาวรส', '💛'),
  _Flavor('Caramel', 'คาราเมล', '🍯'),
  _Flavor('Elderflower', 'เอลเดอร์ฟลาวเวอร์', '🌸'),
  _Flavor('Raspberry', 'ราสป์เบอร์รี', '🫐'),
  _Flavor('Pomegranate', 'ทับทิม', '❤️'),
  _Flavor('Madagascar Vanilla', 'มาดากัสการ์วานิลลา', '🍦'),
  _Flavor('Rose', 'กุหลาบ', '🌹'),
];

// 16 flavors x 5 recipe styles = 80 prototypes.
// The first 50 are alcohol-free; the remaining 30 contain alcohol.
// Quantities are starting points for recipe development, not official brand recipes.
final List<Drink> drinks = List<Drink>.generate(80, (i) {
  final f = _flavors[i ~/ 5];
  final style = i % 5;
  final alcoholic = i >= 50;
  final caffeine = !alcoholic && style == 2;
  final syrup = 'Señorita ${f.en} {syrup} มล.';
  final base = alcoholic
      ? <String>['${style.isEven ? 'วอดก้า' : 'จิน'} 40 มล.', 'โซดา 120 มล.', 'น้ำมะนาว 10 มล.']
      : switch (style) {
          0 => <String>['โซดา 160 มล.', 'น้ำมะนาว 10 มล.'],
          1 => <String>['นมสดหรือนมพืช 180 มล.'],
          2 => <String>['ชาดำชงเย็น 140 มล.', 'น้ำเปล่า 30 มล.'],
          3 => <String>['โซดา 120 มล.', 'น้ำผลไม้ 50 มล.'],
          _ => <String>['โยเกิร์ตรสธรรมชาติ 120 กรัม', 'นม 80 มล.'],
        };
  final suffix = alcoholic
      ? (style.isEven ? 'Gin Fizz' : 'Vodka Spark')
      : const ['Soda Pop', 'Milk Cloud', 'Tea Break', 'Fruit Fizz', 'Yogurt Chill'][0 + style];
  return Drink(
    id: 'senorita-${i + 1}',
    name: '${f.th} $suffix',
    emoji: f.emoji,
    tagline: alcoholic ? 'แก้วชิลสำหรับผู้ใหญ่ในเวลาพักผ่อน' : 'เติมสีสันให้วันธรรมดา',
    flavor: f.en,
    moods: [moods[i % moods.length], moods[(i + 2) % moods.length]],
    tasks: [tasks[i % tasks.length], tasks[(i + 1) % tasks.length]],
    ingredients: [syrup, ...base, 'น้ำแข็ง 1 แก้ว'],
    steps: [
      'ตวง Señorita ${f.en} ตามระดับความหวานที่เลือก',
      'ใส่น้ำแข็งและเติมส่วนผสมอื่นลงในแก้ว',
      'คนให้เข้ากัน ชิมและปรับรสก่อนเสิร์ฟ',
    ],
    caffeinated: caffeine,
    alcoholic: alcoholic,
  );
});
