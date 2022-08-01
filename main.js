(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS
//
// For some reason, tabs can appear in href protocols and it still works.
// So '\tjava\tSCRIPT:alert("!!!")' and 'javascript:alert("!!!")' are the same
// in practice. That is why _VirtualDom_RE_js and _VirtualDom_RE_js_html look
// so freaky.
//
// Pulling the regular expressions out to the top level gives a slight speed
// boost in small benchmarks (4-10%) but hoisting values to reduce allocation
// can be unpredictable in large programs where JIT may have a harder time with
// functions are not fully self-contained. The benefit is more that the js and
// js_html ones are so weird that I prefer to see them near each other.


var _VirtualDom_RE_script = /^script$/i;
var _VirtualDom_RE_on_formAction = /^(on|formAction$)/i;
var _VirtualDom_RE_js = /^\s*j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:/i;
var _VirtualDom_RE_js_html = /^\s*(j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:|d\s*a\s*t\s*a\s*:\s*t\s*e\s*x\s*t\s*\/\s*h\s*t\s*m\s*l\s*(,|;))/i;


function _VirtualDom_noScript(tag)
{
	return _VirtualDom_RE_script.test(tag) ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return _VirtualDom_RE_on_formAction.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return _VirtualDom_RE_js.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return _VirtualDom_RE_js_html.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlJson(value)
{
	return (typeof _Json_unwrap(value) === 'string' && _VirtualDom_RE_js_html.test(_Json_unwrap(value)))
		? _Json_wrap(
			/**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		) : value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2($elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = $elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = $elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}




// STRINGS


var _Parser_isSubString = F5(function(smallString, offset, row, col, bigString)
{
	var smallLength = smallString.length;
	var isGood = offset + smallLength <= bigString.length;

	for (var i = 0; isGood && i < smallLength; )
	{
		var code = bigString.charCodeAt(offset);
		isGood =
			smallString[i++] === bigString[offset++]
			&& (
				code === 0x000A /* \n */
					? ( row++, col=1 )
					: ( col++, (code & 0xF800) === 0xD800 ? smallString[i++] === bigString[offset++] : 1 )
			)
	}

	return _Utils_Tuple3(isGood ? offset : -1, row, col);
});



// CHARS


var _Parser_isSubChar = F3(function(predicate, offset, string)
{
	return (
		string.length <= offset
			? -1
			:
		(string.charCodeAt(offset) & 0xF800) === 0xD800
			? (predicate(_Utils_chr(string.substr(offset, 2))) ? offset + 2 : -1)
			:
		(predicate(_Utils_chr(string[offset]))
			? ((string[offset] === '\n') ? -2 : (offset + 1))
			: -1
		)
	);
});


var _Parser_isAsciiCode = F3(function(code, offset, string)
{
	return string.charCodeAt(offset) === code;
});



// NUMBERS


var _Parser_chompBase10 = F2(function(offset, string)
{
	for (; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (code < 0x30 || 0x39 < code)
		{
			return offset;
		}
	}
	return offset;
});


var _Parser_consumeBase = F3(function(base, offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var digit = string.charCodeAt(offset) - 0x30;
		if (digit < 0 || base <= digit) break;
		total = base * total + digit;
	}
	return _Utils_Tuple2(offset, total);
});


var _Parser_consumeBase16 = F2(function(offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (0x30 <= code && code <= 0x39)
		{
			total = 16 * total + code - 0x30;
		}
		else if (0x41 <= code && code <= 0x46)
		{
			total = 16 * total + code - 55;
		}
		else if (0x61 <= code && code <= 0x66)
		{
			total = 16 * total + code - 87;
		}
		else
		{
			break;
		}
	}
	return _Utils_Tuple2(offset, total);
});



// FIND STRING


var _Parser_findSubString = F5(function(smallString, offset, row, col, bigString)
{
	var newOffset = bigString.indexOf(smallString, offset);
	var target = newOffset < 0 ? bigString.length : newOffset + smallString.length;

	while (offset < target)
	{
		var code = bigString.charCodeAt(offset++);
		code === 0x000A /* \n */
			? ( col=1, row++ )
			: ( col++, (code & 0xF800) === 0xD800 && offset++ )
	}

	return _Utils_Tuple3(newOffset, row, col);
});



// SEND REQUEST

var _Http_toTask = F3(function(router, toTask, request)
{
	return _Scheduler_binding(function(callback)
	{
		function done(response) {
			callback(toTask(request.expect.a(response)));
		}

		var xhr = new XMLHttpRequest();
		xhr.addEventListener('error', function() { done($elm$http$Http$NetworkError_); });
		xhr.addEventListener('timeout', function() { done($elm$http$Http$Timeout_); });
		xhr.addEventListener('load', function() { done(_Http_toResponse(request.expect.b, xhr)); });
		$elm$core$Maybe$isJust(request.tracker) && _Http_track(router, xhr, request.tracker.a);

		try {
			xhr.open(request.method, request.url, true);
		} catch (e) {
			return done($elm$http$Http$BadUrl_(request.url));
		}

		_Http_configureRequest(xhr, request);

		request.body.a && xhr.setRequestHeader('Content-Type', request.body.a);
		xhr.send(request.body.b);

		return function() { xhr.c = true; xhr.abort(); };
	});
});


// CONFIGURE

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.headers; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}
	xhr.timeout = request.timeout.a || 0;
	xhr.responseType = request.expect.d;
	xhr.withCredentials = request.allowCookiesFromOtherDomains;
}


// RESPONSES

function _Http_toResponse(toBody, xhr)
{
	return A2(
		200 <= xhr.status && xhr.status < 300 ? $elm$http$Http$GoodStatus_ : $elm$http$Http$BadStatus_,
		_Http_toMetadata(xhr),
		toBody(xhr.response)
	);
}


// METADATA

function _Http_toMetadata(xhr)
{
	return {
		url: xhr.responseURL,
		statusCode: xhr.status,
		statusText: xhr.statusText,
		headers: _Http_parseHeaders(xhr.getAllResponseHeaders())
	};
}


// HEADERS

function _Http_parseHeaders(rawHeaders)
{
	if (!rawHeaders)
	{
		return $elm$core$Dict$empty;
	}

	var headers = $elm$core$Dict$empty;
	var headerPairs = rawHeaders.split('\r\n');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf(': ');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3($elm$core$Dict$update, key, function(oldValue) {
				return $elm$core$Maybe$Just($elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}
	return headers;
}


// EXPECT

var _Http_expect = F3(function(type, toBody, toValue)
{
	return {
		$: 0,
		d: type,
		b: toBody,
		a: toValue
	};
});

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		d: expect.d,
		b: expect.b,
		a: function(x) { return func(expect.a(x)); }
	};
});

function _Http_toDataView(arrayBuffer)
{
	return new DataView(arrayBuffer);
}


// BODY and PARTS

var _Http_emptyBody = { $: 0 };
var _Http_pair = F2(function(a, b) { return { $: 0, a: a, b: b }; });

function _Http_toFormData(parts)
{
	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}
	return formData;
}

var _Http_bytesToBlob = F2(function(mime, bytes)
{
	return new Blob([bytes], { type: mime });
});


// PROGRESS

function _Http_track(router, xhr, tracker)
{
	// TODO check out lengthComputable on loadstart event

	xhr.upload.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Sending({
			sent: event.loaded,
			size: event.total
		}))));
	});
	xhr.addEventListener('progress', function(event) {
		if (xhr.c) { return; }
		_Scheduler_rawSpawn(A2($elm$core$Platform$sendToSelf, router, _Utils_Tuple2(tracker, $elm$http$Http$Receiving({
			received: event.loaded,
			size: event.lengthComputable ? $elm$core$Maybe$Just(event.total) : $elm$core$Maybe$Nothing
		}))));
	});
}var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $author$project$ScreeptV2$UnimplementedYet = {$: 'UnimplementedYet'};
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$ScreeptV2$Bind = F2(
	function (a, b) {
		return {$: 'Bind', a: a, b: b};
	});
var $author$project$ScreeptV2$Block = function (a) {
	return {$: 'Block', a: a};
};
var $author$project$ScreeptV2$LiteralIdentifier = function (a) {
	return {$: 'LiteralIdentifier', a: a};
};
var $author$project$ScreeptV2$Number = function (a) {
	return {$: 'Number', a: a};
};
var $author$project$ScreeptV2$Text = function (a) {
	return {$: 'Text', a: a};
};
var $author$project$ScreeptV2$TypeError = {$: 'TypeError'};
var $author$project$ScreeptV2$Undefined = {$: 'Undefined'};
var $elm$core$Result$andThen = F2(
	function (callback, result) {
		if (result.$ === 'Ok') {
			var value = result.a;
			return callback(value);
		} else {
			var msg = result.a;
			return $elm$core$Result$Err(msg);
		}
	});
var $elm$core$Result$map2 = F3(
	function (func, ra, rb) {
		if (ra.$ === 'Err') {
			var x = ra.a;
			return $elm$core$Result$Err(x);
		} else {
			var a = ra.a;
			if (rb.$ === 'Err') {
				var x = rb.a;
				return $elm$core$Result$Err(x);
			} else {
				var b = rb.a;
				return $elm$core$Result$Ok(
					A2(func, a, b));
			}
		}
	});
var $elm_community$result_extra$Result$Extra$combine = A2(
	$elm$core$List$foldr,
	$elm$core$Result$map2($elm$core$List$cons),
	$elm$core$Result$Ok(_List_Nil));
var $elm$core$String$fromFloat = _String_fromNumber;
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $author$project$ScreeptV2$stringifyBinaryOperator = function (binaryOp) {
	switch (binaryOp.$) {
		case 'Add':
			return '+';
		case 'Sub':
			return '-';
		case 'Mul':
			return '*';
		case 'Div':
			return '/';
		case 'DivInt':
			return '//';
		case 'Mod':
			return '%%';
		case 'Gt':
			return '>';
		case 'Lt':
			return '<';
		case 'Eq':
			return '==';
		case 'And':
			return '&&';
		default:
			return '||';
	}
};
var $author$project$ScreeptV2$stringifyUnaryOperator = function (unaryOp) {
	if (unaryOp.$ === 'Not') {
		return '!';
	} else {
		return '- ';
	}
};
var $author$project$ScreeptV2$stringifyExpression = function (expression) {
	switch (expression.$) {
		case 'Literal':
			var value = expression.a;
			return $author$project$ScreeptV2$stringifyValue(value);
		case 'Variable':
			var identifier = expression.a;
			return $author$project$ScreeptV2$stringifyIdentifier(identifier);
		case 'UnaryExpression':
			var unaryOp = expression.a;
			var expr = expression.b;
			return _Utils_ap(
				$author$project$ScreeptV2$stringifyUnaryOperator(unaryOp),
				$author$project$ScreeptV2$stringifyExpression(expr));
		case 'BinaryExpression':
			var expr1 = expression.a;
			var binaryOp = expression.b;
			var expr2 = expression.c;
			return '(' + ($author$project$ScreeptV2$stringifyExpression(expr1) + (' ' + ($author$project$ScreeptV2$stringifyBinaryOperator(binaryOp) + (' ' + ($author$project$ScreeptV2$stringifyExpression(expr2) + ')')))));
		case 'TertiaryExpression':
			var expr1 = expression.a;
			var tertiaryOp = expression.b;
			var expr2 = expression.c;
			var expr3 = expression.d;
			return '(' + ($author$project$ScreeptV2$stringifyExpression(expr1) + (' ? ' + ($author$project$ScreeptV2$stringifyExpression(expr2) + (' : ' + ($author$project$ScreeptV2$stringifyExpression(expr3) + ')')))));
		case 'FunctionCall':
			var identifier = expression.a;
			var expressions = expression.b;
			return $author$project$ScreeptV2$stringifyIdentifier(identifier) + ('(' + (A2(
				$elm$core$String$join,
				',',
				A2($elm$core$List$map, $author$project$ScreeptV2$stringifyExpression, expressions)) + ')'));
		default:
			var string = expression.a;
			var expressions = expression.b;
			return string + ('(' + (A2(
				$elm$core$String$join,
				',',
				A2($elm$core$List$map, $author$project$ScreeptV2$stringifyExpression, expressions)) + ')'));
	}
};
var $author$project$ScreeptV2$stringifyIdentifier = function (identifier) {
	if (identifier.$ === 'LiteralIdentifier') {
		var string = identifier.a;
		return string;
	} else {
		var expression = identifier.a;
		return '${' + ($author$project$ScreeptV2$stringifyExpression(expression) + '}');
	}
};
var $author$project$ScreeptV2$stringifyValue = function (value) {
	switch (value.$) {
		case 'Number':
			var _float = value.a;
			return $elm$core$String$fromFloat(_float);
		case 'Text':
			var string = value.a;
			return '\"' + (string + '\"');
		default:
			var expression = value.a;
			return 'FUNC ' + $author$project$ScreeptV2$stringifyExpression(expression);
	}
};
var $author$project$ScreeptV2$getStringFromValue = function (value) {
	switch (value.$) {
		case 'Number':
			var _float = value.a;
			return $elm$core$String$fromFloat(_float);
		case 'Text':
			var string = value.a;
			return string;
		default:
			var expression = value.a;
			return $author$project$ScreeptV2$stringifyExpression(expression);
	}
};
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$random$Random$Generator = function (a) {
	return {$: 'Generator', a: a};
};
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 'Seed', a: a, b: b};
	});
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$random$Random$next = function (_v0) {
	var state0 = _v0.a;
	var incr = _v0.b;
	return A2($elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var $elm$core$Bitwise$xor = _Bitwise_xor;
var $elm$random$Random$peel = function (_v0) {
	var state = _v0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var $elm$random$Random$int = F2(
	function (a, b) {
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v0 = (_Utils_cmp(a, b) < 0) ? _Utils_Tuple2(a, b) : _Utils_Tuple2(b, a);
				var lo = _v0.a;
				var hi = _v0.b;
				var range = (hi - lo) + 1;
				if (!((range - 1) & range)) {
					return _Utils_Tuple2(
						(((range - 1) & $elm$random$Random$peel(seed0)) >>> 0) + lo,
						$elm$random$Random$next(seed0));
				} else {
					var threshhold = (((-range) >>> 0) % range) >>> 0;
					var accountForBias = function (seed) {
						accountForBias:
						while (true) {
							var x = $elm$random$Random$peel(seed);
							var seedN = $elm$random$Random$next(seed);
							if (_Utils_cmp(x, threshhold) < 0) {
								var $temp$seed = seedN;
								seed = $temp$seed;
								continue accountForBias;
							} else {
								return _Utils_Tuple2((x % range) + lo, seedN);
							}
						}
					};
					return accountForBias(seed0);
				}
			});
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $author$project$ScreeptV2$isTruthy = function (value) {
	switch (value.$) {
		case 'Number':
			var n = value.a;
			return !(!n);
		case 'Text':
			var t = value.a;
			return t !== '';
		default:
			return true;
	}
};
var $elm$core$Debug$log = _Debug_log;
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return $elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return $elm$core$Result$Err(e);
		}
	});
var $elm$core$Result$map3 = F4(
	function (func, ra, rb, rc) {
		if (ra.$ === 'Err') {
			var x = ra.a;
			return $elm$core$Result$Err(x);
		} else {
			var a = ra.a;
			if (rb.$ === 'Err') {
				var x = rb.a;
				return $elm$core$Result$Err(x);
			} else {
				var b = rb.a;
				if (rc.$ === 'Err') {
					var x = rc.a;
					return $elm$core$Result$Err(x);
				} else {
					var c = rc.a;
					return $elm$core$Result$Ok(
						A3(func, a, b, c));
				}
			}
		}
	});
var $elm$core$Basics$modBy = _Basics_modBy;
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$ScreeptV2$resolveVariable = F2(
	function (env, _var) {
		return A2(
			$elm$core$Maybe$withDefault,
			$elm$core$Result$Err($author$project$ScreeptV2$Undefined),
			A2(
				$elm$core$Maybe$map,
				$elm$core$Result$Ok,
				A2($elm$core$Dict$get, _var, env.vars)));
	});
var $elm$core$Basics$round = _Basics_round;
var $author$project$ScreeptV2$setVariable = F3(
	function (varName, v, env) {
		var vars = A3($elm$core$Dict$insert, varName, v, env.vars);
		return _Utils_update(
			env,
			{vars: vars});
	});
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $author$project$ScreeptV2$standardLibrary = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2(
			'CONCAT',
			function (args) {
				return $elm$core$Result$Ok(
					$author$project$ScreeptV2$Text(
						A2(
							$elm$core$String$join,
							'',
							A2($elm$core$List$map, $author$project$ScreeptV2$getStringFromValue, args))));
			})
		]));
var $elm$random$Random$step = F2(
	function (_v0, seed) {
		var generator = _v0.a;
		return generator(seed);
	});
var $author$project$ScreeptV2$evaluateBinaryExpression = F4(
	function (env, e1, binaryOp, e2) {
		var floatOperation = F3(
			function (fn, expression1, expression2) {
				var _v17 = _Utils_Tuple2(expression1, expression2);
				if ((_v17.a.$ === 'Number') && (_v17.b.$ === 'Number')) {
					var n1 = _v17.a.a;
					var n2 = _v17.b.a;
					return $elm$core$Result$Ok(
						$author$project$ScreeptV2$Number(
							A2(fn, n1, n2)));
				} else {
					return $elm$core$Result$Err($author$project$ScreeptV2$TypeError);
				}
			});
		return A2(
			$elm$core$Result$andThen,
			function (expr1) {
				return A2(
					$elm$core$Result$andThen,
					function (expr2) {
						switch (binaryOp.$) {
							case 'Add':
								var _v16 = _Utils_Tuple2(expr1, expr2);
								_v16$2:
								while (true) {
									switch (_v16.a.$) {
										case 'Number':
											if (_v16.b.$ === 'Number') {
												var n1 = _v16.a.a;
												var n2 = _v16.b.a;
												return $elm$core$Result$Ok(
													$author$project$ScreeptV2$Number(n1 + n2));
											} else {
												break _v16$2;
											}
										case 'Text':
											if (_v16.b.$ === 'Text') {
												var t1 = _v16.a.a;
												var t2 = _v16.b.a;
												return $elm$core$Result$Ok(
													$author$project$ScreeptV2$Text(
														_Utils_ap(t1, t2)));
											} else {
												break _v16$2;
											}
										default:
											break _v16$2;
									}
								}
								var v1 = _v16.a;
								var v2 = _v16.b;
								return $elm$core$Result$Ok(
									$author$project$ScreeptV2$Text(
										_Utils_ap(
											$author$project$ScreeptV2$getStringFromValue(v1),
											$author$project$ScreeptV2$getStringFromValue(v2))));
							case 'Sub':
								return A3(floatOperation, $elm$core$Basics$sub, expr1, expr2);
							case 'Mul':
								return A3(floatOperation, $elm$core$Basics$mul, expr1, expr2);
							case 'Div':
								return A3(floatOperation, $elm$core$Basics$fdiv, expr1, expr2);
							case 'DivInt':
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return $elm$core$Basics$floor(x / y);
										}),
									expr1,
									expr2);
							case 'Mod':
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return A2(
												$elm$core$Basics$modBy,
												$elm$core$Basics$round(y),
												$elm$core$Basics$round(x));
										}),
									expr1,
									expr2);
							case 'Gt':
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return (_Utils_cmp(x, y) > 0) ? 1 : 0;
										}),
									expr1,
									expr2);
							case 'Lt':
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return (_Utils_cmp(x, y) < 0) ? 1 : 0;
										}),
									expr1,
									expr2);
							case 'Eq':
								return $elm$core$Result$Ok(
									$author$project$ScreeptV2$Number(
										_Utils_eq(expr1, expr2) ? 1 : 0));
							case 'And':
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return (!(x * y)) ? 0 : 1;
										}),
									expr1,
									expr2);
							default:
								return A3(
									floatOperation,
									F2(
										function (x, y) {
											return (!(x + y)) ? 0 : 1;
										}),
									expr1,
									expr2);
						}
					},
					A2($author$project$ScreeptV2$evaluateExpression, env, e2));
			},
			A2($author$project$ScreeptV2$evaluateExpression, env, e1));
	});
var $author$project$ScreeptV2$evaluateExpression = F2(
	function (env, expression) {
		var result = function () {
			switch (expression.$) {
				case 'Literal':
					var valueType = expression.a;
					return $elm$core$Result$Ok(valueType);
				case 'Variable':
					var _var = expression.a;
					return A2(
						$elm$core$Result$andThen,
						$author$project$ScreeptV2$resolveVariable(env),
						A2($author$project$ScreeptV2$resolveIdentifierToString, env, _var));
				case 'UnaryExpression':
					var unaryOp = expression.a;
					var e = expression.b;
					return A3($author$project$ScreeptV2$evaluateUnaryExpression, env, unaryOp, e);
				case 'BinaryExpression':
					var e1 = expression.a;
					var binaryOp = expression.b;
					var e2 = expression.c;
					return A4($author$project$ScreeptV2$evaluateBinaryExpression, env, e1, binaryOp, e2);
				case 'TertiaryExpression':
					var e1 = expression.a;
					var tertiaryOp = expression.b;
					var e2 = expression.c;
					var e3 = expression.d;
					return A5($author$project$ScreeptV2$evaluateTertiaryExpression, env, tertiaryOp, e1, e2, e3);
				case 'FunctionCall':
					var identifier = expression.a;
					var expressions = expression.b;
					return A2(
						$elm$core$Result$andThen,
						function (_var) {
							if (_var.$ === 'Func') {
								var expr = _var.a;
								var runTimeState = function () {
									var varName = function (i) {
										return $author$project$ScreeptV2$LiteralIdentifier(
											'__' + $elm$core$String$fromInt(i + 1));
									};
									var bindings = $author$project$ScreeptV2$Block(
										A2(
											$elm$core$List$map,
											function (_v14) {
												var i = _v14.a;
												var e = _v14.b;
												return A2(
													$author$project$ScreeptV2$Bind,
													varName(i),
													e);
											},
											A2($elm$core$List$indexedMap, $elm$core$Tuple$pair, expressions)));
									return A2(
										$author$project$ScreeptV2$executeStatement,
										bindings,
										_Utils_Tuple2(env, _List_Nil));
								}();
								return A2(
									$elm$core$Result$andThen,
									function (_v13) {
										var boundState = _v13.a;
										return A2($author$project$ScreeptV2$evaluateExpression, boundState, expr);
									},
									runTimeState);
							} else {
								return $elm$core$Result$Err($author$project$ScreeptV2$TypeError);
							}
						},
						A2(
							$elm$core$Result$andThen,
							$author$project$ScreeptV2$resolveVariable(env),
							A2($author$project$ScreeptV2$resolveIdentifierToString, env, identifier)));
				default:
					var func = expression.a;
					var expressions = expression.b;
					return A2(
						$elm$core$Result$andThen,
						function (args) {
							return A2(
								$elm$core$Maybe$withDefault,
								$elm$core$Result$Err($author$project$ScreeptV2$Undefined),
								A2(
									$elm$core$Maybe$map,
									function (f) {
										return f(args);
									},
									A2($elm$core$Dict$get, func, $author$project$ScreeptV2$standardLibrary)));
						},
						$elm_community$result_extra$Result$Extra$combine(
							A2(
								$elm$core$List$map,
								$author$project$ScreeptV2$evaluateExpression(env),
								expressions)));
			}
		}();
		var _v10 = A2(
			$elm$core$Debug$log,
			'EVAL EXPRESSION',
			_Utils_Tuple2(result, expression));
		return result;
	});
var $author$project$ScreeptV2$evaluateTertiaryExpression = F5(
	function (env, tertiaryOp, e1, e2, e3) {
		return A4(
			$elm$core$Result$map3,
			F3(
				function (cond, succ, fail) {
					return $author$project$ScreeptV2$isTruthy(cond) ? succ : fail;
				}),
			A2($author$project$ScreeptV2$evaluateExpression, env, e1),
			A2($author$project$ScreeptV2$evaluateExpression, env, e2),
			A2($author$project$ScreeptV2$evaluateExpression, env, e3));
	});
var $author$project$ScreeptV2$evaluateUnaryExpression = F3(
	function (env, unaryOp, expression) {
		var expr = A2($author$project$ScreeptV2$evaluateExpression, env, expression);
		if (unaryOp.$ === 'Not') {
			return A2(
				$elm$core$Result$map,
				function (value) {
					switch (value.$) {
						case 'Number':
							var n = value.a;
							return $author$project$ScreeptV2$Number(
								(!n) ? 1 : 0);
						case 'Text':
							var t = value.a;
							return $author$project$ScreeptV2$Number(
								($elm$core$String$length(t) > 0) ? 1 : 0);
						default:
							return $author$project$ScreeptV2$Number(0);
					}
				},
				expr);
		} else {
			return A2(
				$elm$core$Result$andThen,
				function (v) {
					if (v.$ === 'Number') {
						var n = v.a;
						return $elm$core$Result$Ok(
							$author$project$ScreeptV2$Number(-n));
					} else {
						return $elm$core$Result$Err($author$project$ScreeptV2$TypeError);
					}
				},
				expr);
		}
	});
var $author$project$ScreeptV2$executeStatement = F2(
	function (statement, _v1) {
		var env = _v1.a;
		var output = _v1.b;
		switch (statement.$) {
			case 'Bind':
				var ident = statement.a;
				var expression = statement.b;
				return A3(
					$elm$core$Result$map2,
					F2(
						function (v, id) {
							return _Utils_Tuple2(
								A3($author$project$ScreeptV2$setVariable, id, v, env),
								output);
						}),
					A2($author$project$ScreeptV2$evaluateExpression, env, expression),
					A2($author$project$ScreeptV2$resolveIdentifierToString, env, ident));
			case 'Block':
				var statements = statement.a;
				return A3(
					$elm$core$List$foldl,
					F2(
						function (s, acc) {
							return A2(
								$elm$core$Result$andThen,
								$author$project$ScreeptV2$executeStatement(s),
								acc);
						}),
					$elm$core$Result$Ok(
						_Utils_Tuple2(env, output)),
					statements);
			case 'Print':
				var expression = statement.a;
				return A2(
					$elm$core$Result$map,
					function (v) {
						var o = function () {
							switch (v.$) {
								case 'Text':
									var t = v.a;
									return t;
								case 'Number':
									var _float = v.a;
									return $elm$core$String$fromFloat(_float);
								default:
									return '<FUNC>';
							}
						}();
						return _Utils_Tuple2(
							env,
							_Utils_ap(
								output,
								_List_fromArray(
									[o])));
					},
					A2($author$project$ScreeptV2$evaluateExpression, env, expression));
			case 'If':
				var expression = statement.a;
				var success = statement.b;
				var failure = statement.c;
				return A2(
					$elm$core$Result$andThen,
					function (v) {
						return A2(
							$author$project$ScreeptV2$executeStatement,
							$author$project$ScreeptV2$isTruthy(v) ? success : failure,
							_Utils_Tuple2(env, output));
					},
					A2($author$project$ScreeptV2$evaluateExpression, env, expression));
			case 'RunProc':
				var procName = statement.a;
				return A2(
					$elm$core$Maybe$withDefault,
					$elm$core$Result$Err($author$project$ScreeptV2$Undefined),
					A2(
						$elm$core$Maybe$map,
						function (proc) {
							var _v4 = A2($elm$core$Debug$log, 'EXECUTING ', proc);
							return A2(
								$author$project$ScreeptV2$executeStatement,
								proc,
								_Utils_Tuple2(env, output));
						},
						A2($elm$core$Dict$get, procName, env.procedures)));
			case 'Rnd':
				var identifier = statement.a;
				var from = statement.b;
				var to = statement.c;
				return A2(
					$elm$core$Result$andThen,
					function (id) {
						return A2(
							$elm$core$Result$andThen,
							function (f) {
								return A2(
									$elm$core$Result$andThen,
									function (t) {
										var _v5 = _Utils_Tuple2(f, t);
										if ((_v5.a.$ === 'Number') && (_v5.b.$ === 'Number')) {
											var x = _v5.a.a;
											var y = _v5.b.a;
											var _v6 = A2(
												$elm$random$Random$step,
												A2(
													$elm$random$Random$int,
													$elm$core$Basics$round(x),
													$elm$core$Basics$round(y)),
												env.rnd);
											var result = _v6.a;
											var newSeed = _v6.b;
											var newState = _Utils_update(
												env,
												{rnd: newSeed});
											return $elm$core$Result$Ok(
												_Utils_Tuple2(
													A3(
														$author$project$ScreeptV2$setVariable,
														id,
														$author$project$ScreeptV2$Number(result),
														newState),
													output));
										} else {
											return $elm$core$Result$Err($author$project$ScreeptV2$TypeError);
										}
									},
									A2($author$project$ScreeptV2$evaluateExpression, env, to));
							},
							A2($author$project$ScreeptV2$evaluateExpression, env, from));
					},
					A2($author$project$ScreeptV2$resolveIdentifierToString, env, identifier));
			default:
				var string = statement.a;
				var procedure = statement.b;
				return $elm$core$Result$Ok(
					_Utils_Tuple2(
						_Utils_update(
							env,
							{
								procedures: A3($elm$core$Dict$insert, string, procedure, env.procedures)
							}),
						output));
		}
	});
var $author$project$ScreeptV2$resolveIdentifierToString = F2(
	function (env, identifier) {
		if (identifier.$ === 'LiteralIdentifier') {
			var string = identifier.a;
			return $elm$core$Result$Ok(string);
		} else {
			var expression = identifier.a;
			return A2(
				$elm$core$Result$map,
				$author$project$ScreeptV2$getStringFromValue,
				A2($author$project$ScreeptV2$evaluateExpression, env, expression));
		}
	});
var $author$project$ScreeptV2$Add = {$: 'Add'};
var $author$project$ScreeptV2$BinaryExpression = F3(
	function (a, b, c) {
		return {$: 'BinaryExpression', a: a, b: b, c: c};
	});
var $author$project$ScreeptV2$Func = function (a) {
	return {$: 'Func', a: a};
};
var $author$project$ScreeptV2$Literal = function (a) {
	return {$: 'Literal', a: a};
};
var $author$project$ScreeptV2$Variable = function (a) {
	return {$: 'Variable', a: a};
};
var $elm$random$Random$initialSeed = function (x) {
	var _v0 = $elm$random$Random$next(
		A2($elm$random$Random$Seed, 0, 1013904223));
	var state1 = _v0.a;
	var incr = _v0.b;
	var state2 = (state1 + x) >>> 0;
	return $elm$random$Random$next(
		A2($elm$random$Random$Seed, state2, incr));
};
var $author$project$ScreeptV2$exampleScreeptState = {
	procedures: $elm$core$Dict$empty,
	rnd: $elm$random$Random$initialSeed(1),
	vars: $elm$core$Dict$fromList(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'int1',
				$author$project$ScreeptV2$Number(-12)),
				_Utils_Tuple2(
				'float1',
				$author$project$ScreeptV2$Number(3.14)),
				_Utils_Tuple2(
				'zero',
				$author$project$ScreeptV2$Number(0)),
				_Utils_Tuple2(
				't1',
				$author$project$ScreeptV2$Text('Jan')),
				_Utils_Tuple2(
				't2',
				$author$project$ScreeptV2$Text('add2')),
				_Utils_Tuple2(
				'f1',
				$author$project$ScreeptV2$Func(
					$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Worked')))),
				_Utils_Tuple2(
				'add2',
				$author$project$ScreeptV2$Func(
					A3(
						$author$project$ScreeptV2$BinaryExpression,
						$author$project$ScreeptV2$Variable(
							$author$project$ScreeptV2$LiteralIdentifier('__1')),
						$author$project$ScreeptV2$Add,
						$author$project$ScreeptV2$Variable(
							$author$project$ScreeptV2$LiteralIdentifier('__2')))))
			]))
};
var $author$project$Main$NotLoaded = {$: 'NotLoaded'};
var $author$project$Main$SeedGenerated = function (a) {
	return {$: 'SeedGenerated', a: a};
};
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $author$project$Main$askforGame = _Platform_outgoingPort(
	'askforGame',
	function ($) {
		return $elm$json$Json$Encode$null;
	});
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$random$Random$Generate = function (a) {
	return {$: 'Generate', a: a};
};
var $elm$time$Time$Name = function (a) {
	return {$: 'Name', a: a};
};
var $elm$time$Time$Offset = function (a) {
	return {$: 'Offset', a: a};
};
var $elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 'Zone', a: a, b: b};
	});
var $elm$time$Time$customZone = $elm$time$Time$Zone;
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $elm$time$Time$now = _Time_now($elm$time$Time$millisToPosix);
var $elm$time$Time$posixToMillis = function (_v0) {
	var millis = _v0.a;
	return millis;
};
var $elm$random$Random$init = A2(
	$elm$core$Task$andThen,
	function (time) {
		return $elm$core$Task$succeed(
			$elm$random$Random$initialSeed(
				$elm$time$Time$posixToMillis(time)));
	},
	$elm$time$Time$now);
var $elm$random$Random$onEffects = F3(
	function (router, commands, seed) {
		if (!commands.b) {
			return $elm$core$Task$succeed(seed);
		} else {
			var generator = commands.a.a;
			var rest = commands.b;
			var _v1 = A2($elm$random$Random$step, generator, seed);
			var value = _v1.a;
			var newSeed = _v1.b;
			return A2(
				$elm$core$Task$andThen,
				function (_v2) {
					return A3($elm$random$Random$onEffects, router, rest, newSeed);
				},
				A2($elm$core$Platform$sendToApp, router, value));
		}
	});
var $elm$random$Random$onSelfMsg = F3(
	function (_v0, _v1, seed) {
		return $elm$core$Task$succeed(seed);
	});
var $elm$random$Random$map = F2(
	function (func, _v0) {
		var genA = _v0.a;
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v1 = genA(seed0);
				var a = _v1.a;
				var seed1 = _v1.b;
				return _Utils_Tuple2(
					func(a),
					seed1);
			});
	});
var $elm$random$Random$cmdMap = F2(
	function (func, _v0) {
		var generator = _v0.a;
		return $elm$random$Random$Generate(
			A2($elm$random$Random$map, func, generator));
	});
_Platform_effectManagers['Random'] = _Platform_createManager($elm$random$Random$init, $elm$random$Random$onEffects, $elm$random$Random$onSelfMsg, $elm$random$Random$cmdMap);
var $elm$random$Random$command = _Platform_leaf('Random');
var $elm$random$Random$generate = F2(
	function (tagger, generator) {
		return $elm$random$Random$command(
			$elm$random$Random$Generate(
				A2($elm$random$Random$map, tagger, generator)));
	});
var $elm$random$Random$map3 = F4(
	function (func, _v0, _v1, _v2) {
		var genA = _v0.a;
		var genB = _v1.a;
		var genC = _v2.a;
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v3 = genA(seed0);
				var a = _v3.a;
				var seed1 = _v3.b;
				var _v4 = genB(seed1);
				var b = _v4.a;
				var seed2 = _v4.b;
				var _v5 = genC(seed2);
				var c = _v5.a;
				var seed3 = _v5.b;
				return _Utils_Tuple2(
					A3(func, a, b, c),
					seed3);
			});
	});
var $elm$core$Bitwise$or = _Bitwise_or;
var $elm$random$Random$independentSeed = $elm$random$Random$Generator(
	function (seed0) {
		var makeIndependentSeed = F3(
			function (state, b, c) {
				return $elm$random$Random$next(
					A2($elm$random$Random$Seed, state, (1 | (b ^ c)) >>> 0));
			});
		var gen = A2($elm$random$Random$int, 0, 4294967295);
		return A2(
			$elm$random$Random$step,
			A4($elm$random$Random$map3, makeIndependentSeed, gen, gen, gen),
			seed0);
	});
var $elm$parser$Parser$ExpectingEnd = {$: 'ExpectingEnd'};
var $elm$parser$Parser$Advanced$Bad = F2(
	function (a, b) {
		return {$: 'Bad', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$Good = F3(
	function (a, b, c) {
		return {$: 'Good', a: a, b: b, c: c};
	});
var $elm$parser$Parser$Advanced$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var $elm$parser$Parser$Advanced$AddRight = F2(
	function (a, b) {
		return {$: 'AddRight', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$DeadEnd = F4(
	function (row, col, problem, contextStack) {
		return {col: col, contextStack: contextStack, problem: problem, row: row};
	});
var $elm$parser$Parser$Advanced$Empty = {$: 'Empty'};
var $elm$parser$Parser$Advanced$fromState = F2(
	function (s, x) {
		return A2(
			$elm$parser$Parser$Advanced$AddRight,
			$elm$parser$Parser$Advanced$Empty,
			A4($elm$parser$Parser$Advanced$DeadEnd, s.row, s.col, x, s.context));
	});
var $elm$parser$Parser$Advanced$end = function (x) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return _Utils_eq(
				$elm$core$String$length(s.src),
				s.offset) ? A3($elm$parser$Parser$Advanced$Good, false, _Utils_Tuple0, s) : A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, x));
		});
};
var $elm$parser$Parser$end = $elm$parser$Parser$Advanced$end($elm$parser$Parser$ExpectingEnd);
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $elm$parser$Parser$Advanced$map2 = F3(
	function (func, _v0, _v1) {
		var parseA = _v0.a;
		var parseB = _v1.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v2 = parseA(s0);
				if (_v2.$ === 'Bad') {
					var p = _v2.a;
					var x = _v2.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v2.a;
					var a = _v2.b;
					var s1 = _v2.c;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3(
							$elm$parser$Parser$Advanced$Good,
							p1 || p2,
							A2(func, a, b),
							s2);
					}
				}
			});
	});
var $elm$parser$Parser$Advanced$ignorer = F2(
	function (keepParser, ignoreParser) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$always, keepParser, ignoreParser);
	});
var $elm$parser$Parser$ignorer = $elm$parser$Parser$Advanced$ignorer;
var $author$project$ParsedEditable$init = F3(
	function (item, parser, formatter) {
		return {
			formatter: formatter,
			_new: $elm$core$Result$Ok(item),
			old: item,
			parser: A2($elm$parser$Parser$ignorer, parser, $elm$parser$Parser$end),
			text: formatter(item)
		};
	});
var $author$project$ScreeptV2$If = F3(
	function (a, b, c) {
		return {$: 'If', a: a, b: b, c: c};
	});
var $elm$parser$Parser$Optional = {$: 'Optional'};
var $author$project$ScreeptV2$Print = function (a) {
	return {$: 'Print', a: a};
};
var $author$project$ScreeptV2$Proc = F2(
	function (a, b) {
		return {$: 'Proc', a: a, b: b};
	});
var $author$project$ScreeptV2$Rnd = F3(
	function (a, b, c) {
		return {$: 'Rnd', a: a, b: b, c: c};
	});
var $author$project$ScreeptV2$RunProc = function (a) {
	return {$: 'RunProc', a: a};
};
var $elm$parser$Parser$Advanced$keeper = F2(
	function (parseFunc, parseArg) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$apL, parseFunc, parseArg);
	});
var $elm$parser$Parser$keeper = $elm$parser$Parser$Advanced$keeper;
var $elm$parser$Parser$ExpectingKeyword = function (a) {
	return {$: 'ExpectingKeyword', a: a};
};
var $elm$parser$Parser$Advanced$Token = F2(
	function (a, b) {
		return {$: 'Token', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$isSubChar = _Parser_isSubChar;
var $elm$parser$Parser$Advanced$isSubString = _Parser_isSubString;
var $elm$core$Basics$not = _Basics_not;
var $elm$parser$Parser$Advanced$keyword = function (_v0) {
	var kwd = _v0.a;
	var expecting = _v0.b;
	var progress = !$elm$core$String$isEmpty(kwd);
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v1 = A5($elm$parser$Parser$Advanced$isSubString, kwd, s.offset, s.row, s.col, s.src);
			var newOffset = _v1.a;
			var newRow = _v1.b;
			var newCol = _v1.c;
			return (_Utils_eq(newOffset, -1) || (0 <= A3(
				$elm$parser$Parser$Advanced$isSubChar,
				function (c) {
					return $elm$core$Char$isAlphaNum(c) || _Utils_eq(
						c,
						_Utils_chr('_'));
				},
				newOffset,
				s.src))) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : A3(
				$elm$parser$Parser$Advanced$Good,
				progress,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: newOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$keyword = function (kwd) {
	return $elm$parser$Parser$Advanced$keyword(
		A2(
			$elm$parser$Parser$Advanced$Token,
			kwd,
			$elm$parser$Parser$ExpectingKeyword(kwd)));
};
var $elm$parser$Parser$Advanced$lazy = function (thunk) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v0 = thunk(_Utils_Tuple0);
			var parse = _v0.a;
			return parse(s);
		});
};
var $elm$parser$Parser$lazy = $elm$parser$Parser$Advanced$lazy;
var $elm$parser$Parser$Advanced$map = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						func(a),
						s1);
				} else {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				}
			});
	});
var $elm$parser$Parser$map = $elm$parser$Parser$Advanced$map;
var $elm$parser$Parser$Advanced$Append = F2(
	function (a, b) {
		return {$: 'Append', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$oneOfHelp = F3(
	function (s0, bag, parsers) {
		oneOfHelp:
		while (true) {
			if (!parsers.b) {
				return A2($elm$parser$Parser$Advanced$Bad, false, bag);
			} else {
				var parse = parsers.a.a;
				var remainingParsers = parsers.b;
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var step = _v1;
					return step;
				} else {
					var step = _v1;
					var p = step.a;
					var x = step.b;
					if (p) {
						return step;
					} else {
						var $temp$s0 = s0,
							$temp$bag = A2($elm$parser$Parser$Advanced$Append, bag, x),
							$temp$parsers = remainingParsers;
						s0 = $temp$s0;
						bag = $temp$bag;
						parsers = $temp$parsers;
						continue oneOfHelp;
					}
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$oneOf = function (parsers) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$oneOfHelp, s, $elm$parser$Parser$Advanced$Empty, parsers);
		});
};
var $elm$parser$Parser$oneOf = $elm$parser$Parser$Advanced$oneOf;
var $author$project$ScreeptV2$ComputedIdentifier = function (a) {
	return {$: 'ComputedIdentifier', a: a};
};
var $author$project$ScreeptV2$Conditional = {$: 'Conditional'};
var $elm$parser$Parser$Forbidden = {$: 'Forbidden'};
var $author$project$ScreeptV2$FunctionCall = F2(
	function (a, b) {
		return {$: 'FunctionCall', a: a, b: b};
	});
var $author$project$ScreeptV2$Negate = {$: 'Negate'};
var $author$project$ScreeptV2$Not = {$: 'Not'};
var $author$project$ScreeptV2$StandardLibrary = F2(
	function (a, b) {
		return {$: 'StandardLibrary', a: a, b: b};
	});
var $author$project$ScreeptV2$TertiaryExpression = F4(
	function (a, b, c, d) {
		return {$: 'TertiaryExpression', a: a, b: b, c: c, d: d};
	});
var $author$project$ScreeptV2$UnaryExpression = F2(
	function (a, b) {
		return {$: 'UnaryExpression', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$andThen = F2(
	function (callback, _v0) {
		var parseA = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parseA(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					var _v2 = callback(a);
					var parseB = _v2.a;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3($elm$parser$Parser$Advanced$Good, p1 || p2, b, s2);
					}
				}
			});
	});
var $elm$parser$Parser$andThen = $elm$parser$Parser$Advanced$andThen;
var $elm$parser$Parser$Advanced$backtrackable = function (_v0) {
	var parse = _v0.a;
	return $elm$parser$Parser$Advanced$Parser(
		function (s0) {
			var _v1 = parse(s0);
			if (_v1.$ === 'Bad') {
				var x = _v1.b;
				return A2($elm$parser$Parser$Advanced$Bad, false, x);
			} else {
				var a = _v1.b;
				var s1 = _v1.c;
				return A3($elm$parser$Parser$Advanced$Good, false, a, s1);
			}
		});
};
var $elm$parser$Parser$backtrackable = $elm$parser$Parser$Advanced$backtrackable;
var $elm$parser$Parser$Advanced$chompWhileHelp = F5(
	function (isGood, offset, row, col, s0) {
		chompWhileHelp:
		while (true) {
			var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, offset, s0.src);
			if (_Utils_eq(newOffset, -1)) {
				return A3(
					$elm$parser$Parser$Advanced$Good,
					_Utils_cmp(s0.offset, offset) < 0,
					_Utils_Tuple0,
					{col: col, context: s0.context, indent: s0.indent, offset: offset, row: row, src: s0.src});
			} else {
				if (_Utils_eq(newOffset, -2)) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				} else {
					var $temp$isGood = isGood,
						$temp$offset = newOffset,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$chompWhile = function (isGood) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A5($elm$parser$Parser$Advanced$chompWhileHelp, isGood, s.offset, s.row, s.col, s);
		});
};
var $elm$parser$Parser$chompWhile = $elm$parser$Parser$Advanced$chompWhile;
var $elm$parser$Parser$ExpectingFloat = {$: 'ExpectingFloat'};
var $elm$parser$Parser$Advanced$consumeBase = _Parser_consumeBase;
var $elm$parser$Parser$Advanced$consumeBase16 = _Parser_consumeBase16;
var $elm$parser$Parser$Advanced$bumpOffset = F2(
	function (newOffset, s) {
		return {col: s.col + (newOffset - s.offset), context: s.context, indent: s.indent, offset: newOffset, row: s.row, src: s.src};
	});
var $elm$parser$Parser$Advanced$chompBase10 = _Parser_chompBase10;
var $elm$parser$Parser$Advanced$isAsciiCode = _Parser_isAsciiCode;
var $elm$parser$Parser$Advanced$consumeExp = F2(
	function (offset, src) {
		if (A3($elm$parser$Parser$Advanced$isAsciiCode, 101, offset, src) || A3($elm$parser$Parser$Advanced$isAsciiCode, 69, offset, src)) {
			var eOffset = offset + 1;
			var expOffset = (A3($elm$parser$Parser$Advanced$isAsciiCode, 43, eOffset, src) || A3($elm$parser$Parser$Advanced$isAsciiCode, 45, eOffset, src)) ? (eOffset + 1) : eOffset;
			var newOffset = A2($elm$parser$Parser$Advanced$chompBase10, expOffset, src);
			return _Utils_eq(expOffset, newOffset) ? (-newOffset) : newOffset;
		} else {
			return offset;
		}
	});
var $elm$parser$Parser$Advanced$consumeDotAndExp = F2(
	function (offset, src) {
		return A3($elm$parser$Parser$Advanced$isAsciiCode, 46, offset, src) ? A2(
			$elm$parser$Parser$Advanced$consumeExp,
			A2($elm$parser$Parser$Advanced$chompBase10, offset + 1, src),
			src) : A2($elm$parser$Parser$Advanced$consumeExp, offset, src);
	});
var $elm$parser$Parser$Advanced$finalizeInt = F5(
	function (invalid, handler, startOffset, _v0, s) {
		var endOffset = _v0.a;
		var n = _v0.b;
		if (handler.$ === 'Err') {
			var x = handler.a;
			return A2(
				$elm$parser$Parser$Advanced$Bad,
				true,
				A2($elm$parser$Parser$Advanced$fromState, s, x));
		} else {
			var toValue = handler.a;
			return _Utils_eq(startOffset, endOffset) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				_Utils_cmp(s.offset, startOffset) < 0,
				A2($elm$parser$Parser$Advanced$fromState, s, invalid)) : A3(
				$elm$parser$Parser$Advanced$Good,
				true,
				toValue(n),
				A2($elm$parser$Parser$Advanced$bumpOffset, endOffset, s));
		}
	});
var $elm$parser$Parser$Advanced$fromInfo = F4(
	function (row, col, x, context) {
		return A2(
			$elm$parser$Parser$Advanced$AddRight,
			$elm$parser$Parser$Advanced$Empty,
			A4($elm$parser$Parser$Advanced$DeadEnd, row, col, x, context));
	});
var $elm$core$String$toFloat = _String_toFloat;
var $elm$parser$Parser$Advanced$finalizeFloat = F6(
	function (invalid, expecting, intSettings, floatSettings, intPair, s) {
		var intOffset = intPair.a;
		var floatOffset = A2($elm$parser$Parser$Advanced$consumeDotAndExp, intOffset, s.src);
		if (floatOffset < 0) {
			return A2(
				$elm$parser$Parser$Advanced$Bad,
				true,
				A4($elm$parser$Parser$Advanced$fromInfo, s.row, s.col - (floatOffset + s.offset), invalid, s.context));
		} else {
			if (_Utils_eq(s.offset, floatOffset)) {
				return A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, expecting));
			} else {
				if (_Utils_eq(intOffset, floatOffset)) {
					return A5($elm$parser$Parser$Advanced$finalizeInt, invalid, intSettings, s.offset, intPair, s);
				} else {
					if (floatSettings.$ === 'Err') {
						var x = floatSettings.a;
						return A2(
							$elm$parser$Parser$Advanced$Bad,
							true,
							A2($elm$parser$Parser$Advanced$fromState, s, invalid));
					} else {
						var toValue = floatSettings.a;
						var _v1 = $elm$core$String$toFloat(
							A3($elm$core$String$slice, s.offset, floatOffset, s.src));
						if (_v1.$ === 'Nothing') {
							return A2(
								$elm$parser$Parser$Advanced$Bad,
								true,
								A2($elm$parser$Parser$Advanced$fromState, s, invalid));
						} else {
							var n = _v1.a;
							return A3(
								$elm$parser$Parser$Advanced$Good,
								true,
								toValue(n),
								A2($elm$parser$Parser$Advanced$bumpOffset, floatOffset, s));
						}
					}
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$number = function (c) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			if (A3($elm$parser$Parser$Advanced$isAsciiCode, 48, s.offset, s.src)) {
				var zeroOffset = s.offset + 1;
				var baseOffset = zeroOffset + 1;
				return A3($elm$parser$Parser$Advanced$isAsciiCode, 120, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.hex,
					baseOffset,
					A2($elm$parser$Parser$Advanced$consumeBase16, baseOffset, s.src),
					s) : (A3($elm$parser$Parser$Advanced$isAsciiCode, 111, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.octal,
					baseOffset,
					A3($elm$parser$Parser$Advanced$consumeBase, 8, baseOffset, s.src),
					s) : (A3($elm$parser$Parser$Advanced$isAsciiCode, 98, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.binary,
					baseOffset,
					A3($elm$parser$Parser$Advanced$consumeBase, 2, baseOffset, s.src),
					s) : A6(
					$elm$parser$Parser$Advanced$finalizeFloat,
					c.invalid,
					c.expecting,
					c._int,
					c._float,
					_Utils_Tuple2(zeroOffset, 0),
					s)));
			} else {
				return A6(
					$elm$parser$Parser$Advanced$finalizeFloat,
					c.invalid,
					c.expecting,
					c._int,
					c._float,
					A3($elm$parser$Parser$Advanced$consumeBase, 10, s.offset, s.src),
					s);
			}
		});
};
var $elm$parser$Parser$Advanced$float = F2(
	function (expecting, invalid) {
		return $elm$parser$Parser$Advanced$number(
			{
				binary: $elm$core$Result$Err(invalid),
				expecting: expecting,
				_float: $elm$core$Result$Ok($elm$core$Basics$identity),
				hex: $elm$core$Result$Err(invalid),
				_int: $elm$core$Result$Ok($elm$core$Basics$toFloat),
				invalid: invalid,
				octal: $elm$core$Result$Err(invalid)
			});
	});
var $elm$parser$Parser$float = A2($elm$parser$Parser$Advanced$float, $elm$parser$Parser$ExpectingFloat, $elm$parser$Parser$ExpectingFloat);
var $elm$parser$Parser$Advanced$mapChompedString = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						A2(
							func,
							A3($elm$core$String$slice, s0.offset, s1.offset, s0.src),
							a),
						s1);
				}
			});
	});
var $elm$parser$Parser$Advanced$getChompedString = function (parser) {
	return A2($elm$parser$Parser$Advanced$mapChompedString, $elm$core$Basics$always, parser);
};
var $elm$parser$Parser$getChompedString = $elm$parser$Parser$Advanced$getChompedString;
var $author$project$ScreeptV2$And = {$: 'And'};
var $author$project$ScreeptV2$Div = {$: 'Div'};
var $author$project$ScreeptV2$DivInt = {$: 'DivInt'};
var $author$project$ScreeptV2$Eq = {$: 'Eq'};
var $author$project$ScreeptV2$Gt = {$: 'Gt'};
var $author$project$ScreeptV2$Lt = {$: 'Lt'};
var $author$project$ScreeptV2$Mod = {$: 'Mod'};
var $author$project$ScreeptV2$Mul = {$: 'Mul'};
var $author$project$ScreeptV2$Or = {$: 'Or'};
var $author$project$ScreeptV2$Sub = {$: 'Sub'};
var $elm$parser$Parser$Advanced$succeed = function (a) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$Good, false, a, s);
		});
};
var $elm$parser$Parser$succeed = $elm$parser$Parser$Advanced$succeed;
var $elm$parser$Parser$ExpectingSymbol = function (a) {
	return {$: 'ExpectingSymbol', a: a};
};
var $elm$parser$Parser$Advanced$token = function (_v0) {
	var str = _v0.a;
	var expecting = _v0.b;
	var progress = !$elm$core$String$isEmpty(str);
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v1 = A5($elm$parser$Parser$Advanced$isSubString, str, s.offset, s.row, s.col, s.src);
			var newOffset = _v1.a;
			var newRow = _v1.b;
			var newCol = _v1.c;
			return _Utils_eq(newOffset, -1) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : A3(
				$elm$parser$Parser$Advanced$Good,
				progress,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: newOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$Advanced$symbol = $elm$parser$Parser$Advanced$token;
var $elm$parser$Parser$symbol = function (str) {
	return $elm$parser$Parser$Advanced$symbol(
		A2(
			$elm$parser$Parser$Advanced$Token,
			str,
			$elm$parser$Parser$ExpectingSymbol(str)));
};
var $author$project$ScreeptV2$parserBinaryOp = $elm$parser$Parser$oneOf(
	_List_fromArray(
		[
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Add),
			$elm$parser$Parser$symbol('+')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Sub),
			$elm$parser$Parser$symbol('-')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Mul),
			$elm$parser$Parser$symbol('*')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$DivInt),
			$elm$parser$Parser$symbol('//')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Div),
			$elm$parser$Parser$symbol('/')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Mod),
			$elm$parser$Parser$symbol('%%')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Gt),
			$elm$parser$Parser$symbol('>')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Lt),
			$elm$parser$Parser$symbol('<')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Eq),
			$elm$parser$Parser$symbol('==')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$And),
			$elm$parser$Parser$symbol('&&')),
			A2(
			$elm$parser$Parser$ignorer,
			$elm$parser$Parser$succeed($author$project$ScreeptV2$Or),
			$elm$parser$Parser$symbol('||'))
		]));
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $elm$parser$Parser$ExpectingVariable = {$: 'ExpectingVariable'};
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (_v0.$ === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var $elm$core$Set$member = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return A2($elm$core$Dict$member, key, dict);
	});
var $elm$parser$Parser$Advanced$varHelp = F7(
	function (isGood, offset, row, col, src, indent, context) {
		varHelp:
		while (true) {
			var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, offset, src);
			if (_Utils_eq(newOffset, -1)) {
				return {col: col, context: context, indent: indent, offset: offset, row: row, src: src};
			} else {
				if (_Utils_eq(newOffset, -2)) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$src = src,
						$temp$indent = indent,
						$temp$context = context;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					context = $temp$context;
					continue varHelp;
				} else {
					var $temp$isGood = isGood,
						$temp$offset = newOffset,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent,
						$temp$context = context;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					context = $temp$context;
					continue varHelp;
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$variable = function (i) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var firstOffset = A3($elm$parser$Parser$Advanced$isSubChar, i.start, s.offset, s.src);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, i.expecting));
			} else {
				var s1 = _Utils_eq(firstOffset, -2) ? A7($elm$parser$Parser$Advanced$varHelp, i.inner, s.offset + 1, s.row + 1, 1, s.src, s.indent, s.context) : A7($elm$parser$Parser$Advanced$varHelp, i.inner, firstOffset, s.row, s.col + 1, s.src, s.indent, s.context);
				var name = A3($elm$core$String$slice, s.offset, s1.offset, s.src);
				return A2($elm$core$Set$member, name, i.reserved) ? A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, i.expecting)) : A3($elm$parser$Parser$Advanced$Good, true, name, s1);
			}
		});
};
var $elm$parser$Parser$variable = function (i) {
	return $elm$parser$Parser$Advanced$variable(
		{expecting: $elm$parser$Parser$ExpectingVariable, inner: i.inner, reserved: i.reserved, start: i.start});
};
var $author$project$ScreeptV2$parserLiteralIdentifier = $elm$parser$Parser$variable(
	{
		inner: function (c) {
			return $elm$core$Char$isAlphaNum(c) || _Utils_eq(
				c,
				_Utils_chr('_'));
		},
		reserved: $elm$core$Set$empty,
		start: function (c) {
			return ($elm$core$Char$isAlphaNum(c) && $elm$core$Char$isLower(c)) || (_Utils_eq(
				c,
				_Utils_chr('_')) && (!_Utils_eq(
				c,
				_Utils_chr('e'))));
		}
	});
var $author$project$ScreeptV2$parserStandardFunction = function (string) {
	return A2(
		$elm$parser$Parser$andThen,
		function (_v0) {
			return $elm$parser$Parser$succeed(string);
		},
		$elm$parser$Parser$keyword(string));
};
var $author$project$ScreeptV2$parserStandardLibrary = $elm$parser$Parser$oneOf(
	A2(
		$elm$core$List$map,
		$author$project$ScreeptV2$parserStandardFunction,
		$elm$core$Dict$keys($author$project$ScreeptV2$standardLibrary)));
var $elm$parser$Parser$Advanced$loopHelp = F4(
	function (p, state, callback, s0) {
		loopHelp:
		while (true) {
			var _v0 = callback(state);
			var parse = _v0.a;
			var _v1 = parse(s0);
			if (_v1.$ === 'Good') {
				var p1 = _v1.a;
				var step = _v1.b;
				var s1 = _v1.c;
				if (step.$ === 'Loop') {
					var newState = step.a;
					var $temp$p = p || p1,
						$temp$state = newState,
						$temp$callback = callback,
						$temp$s0 = s1;
					p = $temp$p;
					state = $temp$state;
					callback = $temp$callback;
					s0 = $temp$s0;
					continue loopHelp;
				} else {
					var result = step.a;
					return A3($elm$parser$Parser$Advanced$Good, p || p1, result, s1);
				}
			} else {
				var p1 = _v1.a;
				var x = _v1.b;
				return A2($elm$parser$Parser$Advanced$Bad, p || p1, x);
			}
		}
	});
var $elm$parser$Parser$Advanced$loop = F2(
	function (state, callback) {
		return $elm$parser$Parser$Advanced$Parser(
			function (s) {
				return A4($elm$parser$Parser$Advanced$loopHelp, false, state, callback, s);
			});
	});
var $elm$parser$Parser$Advanced$Done = function (a) {
	return {$: 'Done', a: a};
};
var $elm$parser$Parser$Advanced$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $elm$parser$Parser$Advanced$revAlways = F2(
	function (_v0, b) {
		return b;
	});
var $elm$parser$Parser$Advanced$skip = F2(
	function (iParser, kParser) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$parser$Parser$Advanced$revAlways, iParser, kParser);
	});
var $elm$parser$Parser$Advanced$sequenceEndForbidden = F5(
	function (ender, ws, parseItem, sep, revItems) {
		var chompRest = function (item) {
			return A5(
				$elm$parser$Parser$Advanced$sequenceEndForbidden,
				ender,
				ws,
				parseItem,
				sep,
				A2($elm$core$List$cons, item, revItems));
		};
		return A2(
			$elm$parser$Parser$Advanced$skip,
			ws,
			$elm$parser$Parser$Advanced$oneOf(
				_List_fromArray(
					[
						A2(
						$elm$parser$Parser$Advanced$skip,
						sep,
						A2(
							$elm$parser$Parser$Advanced$skip,
							ws,
							A2(
								$elm$parser$Parser$Advanced$map,
								function (item) {
									return $elm$parser$Parser$Advanced$Loop(
										A2($elm$core$List$cons, item, revItems));
								},
								parseItem))),
						A2(
						$elm$parser$Parser$Advanced$map,
						function (_v0) {
							return $elm$parser$Parser$Advanced$Done(
								$elm$core$List$reverse(revItems));
						},
						ender)
					])));
	});
var $elm$parser$Parser$Advanced$sequenceEndMandatory = F4(
	function (ws, parseItem, sep, revItems) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$Advanced$map,
					function (item) {
						return $elm$parser$Parser$Advanced$Loop(
							A2($elm$core$List$cons, item, revItems));
					},
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						parseItem,
						A2(
							$elm$parser$Parser$Advanced$ignorer,
							ws,
							A2($elm$parser$Parser$Advanced$ignorer, sep, ws)))),
					A2(
					$elm$parser$Parser$Advanced$map,
					function (_v0) {
						return $elm$parser$Parser$Advanced$Done(
							$elm$core$List$reverse(revItems));
					},
					$elm$parser$Parser$Advanced$succeed(_Utils_Tuple0))
				]));
	});
var $elm$parser$Parser$Advanced$sequenceEndOptional = F5(
	function (ender, ws, parseItem, sep, revItems) {
		var parseEnd = A2(
			$elm$parser$Parser$Advanced$map,
			function (_v0) {
				return $elm$parser$Parser$Advanced$Done(
					$elm$core$List$reverse(revItems));
			},
			ender);
		return A2(
			$elm$parser$Parser$Advanced$skip,
			ws,
			$elm$parser$Parser$Advanced$oneOf(
				_List_fromArray(
					[
						A2(
						$elm$parser$Parser$Advanced$skip,
						sep,
						A2(
							$elm$parser$Parser$Advanced$skip,
							ws,
							$elm$parser$Parser$Advanced$oneOf(
								_List_fromArray(
									[
										A2(
										$elm$parser$Parser$Advanced$map,
										function (item) {
											return $elm$parser$Parser$Advanced$Loop(
												A2($elm$core$List$cons, item, revItems));
										},
										parseItem),
										parseEnd
									])))),
						parseEnd
					])));
	});
var $elm$parser$Parser$Advanced$sequenceEnd = F5(
	function (ender, ws, parseItem, sep, trailing) {
		var chompRest = function (item) {
			switch (trailing.$) {
				case 'Forbidden':
					return A2(
						$elm$parser$Parser$Advanced$loop,
						_List_fromArray(
							[item]),
						A4($elm$parser$Parser$Advanced$sequenceEndForbidden, ender, ws, parseItem, sep));
				case 'Optional':
					return A2(
						$elm$parser$Parser$Advanced$loop,
						_List_fromArray(
							[item]),
						A4($elm$parser$Parser$Advanced$sequenceEndOptional, ender, ws, parseItem, sep));
				default:
					return A2(
						$elm$parser$Parser$Advanced$ignorer,
						A2(
							$elm$parser$Parser$Advanced$skip,
							ws,
							A2(
								$elm$parser$Parser$Advanced$skip,
								sep,
								A2(
									$elm$parser$Parser$Advanced$skip,
									ws,
									A2(
										$elm$parser$Parser$Advanced$loop,
										_List_fromArray(
											[item]),
										A3($elm$parser$Parser$Advanced$sequenceEndMandatory, ws, parseItem, sep))))),
						ender);
			}
		};
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($elm$parser$Parser$Advanced$andThen, chompRest, parseItem),
					A2(
					$elm$parser$Parser$Advanced$map,
					function (_v0) {
						return _List_Nil;
					},
					ender)
				]));
	});
var $elm$parser$Parser$Advanced$sequence = function (i) {
	return A2(
		$elm$parser$Parser$Advanced$skip,
		$elm$parser$Parser$Advanced$token(i.start),
		A2(
			$elm$parser$Parser$Advanced$skip,
			i.spaces,
			A5(
				$elm$parser$Parser$Advanced$sequenceEnd,
				$elm$parser$Parser$Advanced$token(i.end),
				i.spaces,
				i.item,
				$elm$parser$Parser$Advanced$token(i.separator),
				i.trailing)));
};
var $elm$parser$Parser$Advanced$Forbidden = {$: 'Forbidden'};
var $elm$parser$Parser$Advanced$Mandatory = {$: 'Mandatory'};
var $elm$parser$Parser$Advanced$Optional = {$: 'Optional'};
var $elm$parser$Parser$toAdvancedTrailing = function (trailing) {
	switch (trailing.$) {
		case 'Forbidden':
			return $elm$parser$Parser$Advanced$Forbidden;
		case 'Optional':
			return $elm$parser$Parser$Advanced$Optional;
		default:
			return $elm$parser$Parser$Advanced$Mandatory;
	}
};
var $elm$parser$Parser$Expecting = function (a) {
	return {$: 'Expecting', a: a};
};
var $elm$parser$Parser$toToken = function (str) {
	return A2(
		$elm$parser$Parser$Advanced$Token,
		str,
		$elm$parser$Parser$Expecting(str));
};
var $elm$parser$Parser$sequence = function (i) {
	return $elm$parser$Parser$Advanced$sequence(
		{
			end: $elm$parser$Parser$toToken(i.end),
			item: i.item,
			separator: $elm$parser$Parser$toToken(i.separator),
			spaces: i.spaces,
			start: $elm$parser$Parser$toToken(i.start),
			trailing: $elm$parser$Parser$toAdvancedTrailing(i.trailing)
		});
};
var $elm$parser$Parser$Advanced$spaces = $elm$parser$Parser$Advanced$chompWhile(
	function (c) {
		return _Utils_eq(
			c,
			_Utils_chr(' ')) || (_Utils_eq(
			c,
			_Utils_chr('\n')) || _Utils_eq(
			c,
			_Utils_chr('\r')));
	});
var $elm$parser$Parser$spaces = $elm$parser$Parser$Advanced$spaces;
function $author$project$ScreeptV2$cyclic$parserExpression() {
	return $elm$parser$Parser$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					$elm$parser$Parser$succeed($author$project$ScreeptV2$UnaryExpression),
					$elm$parser$Parser$oneOf(
						_List_fromArray(
							[
								A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($author$project$ScreeptV2$Not),
								$elm$parser$Parser$symbol('!')),
								A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($author$project$ScreeptV2$Negate),
								$elm$parser$Parser$symbol('- '))
							]))),
				$elm$parser$Parser$lazy(
					function (_v3) {
						return $author$project$ScreeptV2$cyclic$parserExpression();
					})),
				$elm$parser$Parser$backtrackable(
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$keeper,
							A2(
								$elm$parser$Parser$keeper,
								A2(
									$elm$parser$Parser$ignorer,
									$elm$parser$Parser$succeed($author$project$ScreeptV2$TertiaryExpression),
									$elm$parser$Parser$symbol('(')),
								A2(
									$elm$parser$Parser$ignorer,
									$elm$parser$Parser$lazy(
										function (_v4) {
											return $author$project$ScreeptV2$cyclic$parserExpression();
										}),
									$elm$parser$Parser$spaces)),
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$oneOf(
									_List_fromArray(
										[
											A2(
											$elm$parser$Parser$ignorer,
											$elm$parser$Parser$succeed($author$project$ScreeptV2$Conditional),
											$elm$parser$Parser$symbol('?'))
										])),
								$elm$parser$Parser$spaces)),
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								A2(
									$elm$parser$Parser$ignorer,
									$elm$parser$Parser$lazy(
										function (_v5) {
											return $author$project$ScreeptV2$cyclic$parserExpression();
										}),
									$elm$parser$Parser$spaces),
								$elm$parser$Parser$oneOf(
									_List_fromArray(
										[
											$elm$parser$Parser$symbol(':')
										]))),
							$elm$parser$Parser$spaces)),
					A2(
						$elm$parser$Parser$ignorer,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$lazy(
								function (_v6) {
									return $author$project$ScreeptV2$cyclic$parserExpression();
								}),
							$elm$parser$Parser$spaces),
						$elm$parser$Parser$symbol(')')))),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$succeed($author$project$ScreeptV2$BinaryExpression),
							$elm$parser$Parser$symbol('(')),
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$lazy(
								function (_v7) {
									return $author$project$ScreeptV2$cyclic$parserExpression();
								}),
							$elm$parser$Parser$spaces)),
					A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserBinaryOp, $elm$parser$Parser$spaces)),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$lazy(
						function (_v8) {
							return $author$project$ScreeptV2$cyclic$parserExpression();
						}),
					$elm$parser$Parser$symbol(')'))),
				A2(
				$elm$parser$Parser$map,
				$author$project$ScreeptV2$Literal,
				$author$project$ScreeptV2$cyclic$parserValue()),
				A2(
				$elm$parser$Parser$andThen,
				function (v) {
					return $elm$parser$Parser$oneOf(
						_List_fromArray(
							[
								A2(
								$elm$parser$Parser$keeper,
								$elm$parser$Parser$succeed(
									$author$project$ScreeptV2$FunctionCall(v)),
								$author$project$ScreeptV2$cyclic$parserArguments()),
								$elm$parser$Parser$succeed(
								$author$project$ScreeptV2$Variable(v))
							]));
				},
				$author$project$ScreeptV2$cyclic$parserIdentifier()),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					$elm$parser$Parser$succeed($author$project$ScreeptV2$StandardLibrary),
					$author$project$ScreeptV2$parserStandardLibrary),
				$author$project$ScreeptV2$cyclic$parserArguments())
			]));
}
function $author$project$ScreeptV2$cyclic$parserArguments() {
	return $elm$parser$Parser$sequence(
		{
			end: ')',
			item: $elm$parser$Parser$lazy(
				function (_v2) {
					return $author$project$ScreeptV2$cyclic$parserExpression();
				}),
			separator: ',',
			spaces: $elm$parser$Parser$spaces,
			start: '(',
			trailing: $elm$parser$Parser$Forbidden
		});
}
function $author$project$ScreeptV2$cyclic$parserIdentifier() {
	return $elm$parser$Parser$oneOf(
		_List_fromArray(
			[
				A2($elm$parser$Parser$map, $author$project$ScreeptV2$LiteralIdentifier, $author$project$ScreeptV2$parserLiteralIdentifier),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($author$project$ScreeptV2$ComputedIdentifier),
					$elm$parser$Parser$symbol('${')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$lazy(
						function (_v1) {
							return $author$project$ScreeptV2$cyclic$parserExpression();
						}),
					$elm$parser$Parser$symbol('}')))
			]));
}
function $author$project$ScreeptV2$cyclic$parserValue() {
	return $elm$parser$Parser$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$parser$Parser$map,
				$author$project$ScreeptV2$Number,
				$elm$parser$Parser$oneOf(
					_List_fromArray(
						[
							A2(
							$elm$parser$Parser$keeper,
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($elm$core$Basics$negate),
								$elm$parser$Parser$symbol('-')),
							$elm$parser$Parser$float),
							$elm$parser$Parser$float
						]))),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($author$project$ScreeptV2$Text),
					$elm$parser$Parser$symbol('\"')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getChompedString(
						$elm$parser$Parser$chompWhile(
							function (c) {
								return !_Utils_eq(
									c,
									_Utils_chr('\"'));
							})),
					$elm$parser$Parser$symbol('\"'))),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$succeed($author$project$ScreeptV2$Func),
						$elm$parser$Parser$keyword('FUNC')),
					$elm$parser$Parser$spaces),
				$elm$parser$Parser$lazy(
					function (_v0) {
						return $author$project$ScreeptV2$cyclic$parserExpression();
					}))
			]));
}
try {
	var $author$project$ScreeptV2$parserExpression = $author$project$ScreeptV2$cyclic$parserExpression();
	$author$project$ScreeptV2$cyclic$parserExpression = function () {
		return $author$project$ScreeptV2$parserExpression;
	};
	var $author$project$ScreeptV2$parserArguments = $author$project$ScreeptV2$cyclic$parserArguments();
	$author$project$ScreeptV2$cyclic$parserArguments = function () {
		return $author$project$ScreeptV2$parserArguments;
	};
	var $author$project$ScreeptV2$parserIdentifier = $author$project$ScreeptV2$cyclic$parserIdentifier();
	$author$project$ScreeptV2$cyclic$parserIdentifier = function () {
		return $author$project$ScreeptV2$parserIdentifier;
	};
	var $author$project$ScreeptV2$parserValue = $author$project$ScreeptV2$cyclic$parserValue();
	$author$project$ScreeptV2$cyclic$parserValue = function () {
		return $author$project$ScreeptV2$parserValue;
	};
} catch ($) {
	throw 'Some top-level definitions from `ScreeptV2` are causing infinite recursion:\n\n  ┌─────┐\n  │    parserExpression\n  │     ↓\n  │    parserArguments\n  │     ↓\n  │    parserIdentifier\n  │     ↓\n  │    parserValue\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
function $author$project$ScreeptV2$cyclic$parserStatement() {
	return $elm$parser$Parser$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					$elm$parser$Parser$succeed($author$project$ScreeptV2$Bind),
					A2(
						$elm$parser$Parser$ignorer,
						A2(
							$elm$parser$Parser$ignorer,
							A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserIdentifier, $elm$parser$Parser$spaces),
							$elm$parser$Parser$symbol('=')),
						$elm$parser$Parser$spaces)),
				$author$project$ScreeptV2$parserExpression),
				A2(
				$elm$parser$Parser$map,
				$author$project$ScreeptV2$Block,
				$elm$parser$Parser$sequence(
					{
						end: '}',
						item: $elm$parser$Parser$lazy(
							function (_v0) {
								return $author$project$ScreeptV2$cyclic$parserStatement();
							}),
						separator: ';',
						spaces: $elm$parser$Parser$spaces,
						start: '{',
						trailing: $elm$parser$Parser$Optional
					})),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$succeed($author$project$ScreeptV2$Print),
						$elm$parser$Parser$keyword('PRINT')),
					$elm$parser$Parser$spaces),
				$author$project$ScreeptV2$parserExpression),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($author$project$ScreeptV2$If),
								$elm$parser$Parser$keyword('IF')),
							$elm$parser$Parser$spaces),
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserExpression, $elm$parser$Parser$spaces),
								$elm$parser$Parser$keyword('THEN')),
							$elm$parser$Parser$spaces)),
					A2(
						$elm$parser$Parser$ignorer,
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$lazy(
									function (_v1) {
										return $author$project$ScreeptV2$cyclic$parserStatement();
									}),
								$elm$parser$Parser$spaces),
							$elm$parser$Parser$keyword('ELSE')),
						$elm$parser$Parser$spaces)),
				$elm$parser$Parser$lazy(
					function (_v2) {
						return $author$project$ScreeptV2$cyclic$parserStatement();
					})),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$succeed($author$project$ScreeptV2$RunProc),
						$elm$parser$Parser$keyword('RUN')),
					$elm$parser$Parser$spaces),
				$author$project$ScreeptV2$parserLiteralIdentifier),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($author$project$ScreeptV2$Rnd),
								$elm$parser$Parser$keyword('RND')),
							$elm$parser$Parser$spaces),
						A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserIdentifier, $elm$parser$Parser$spaces)),
					A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserExpression, $elm$parser$Parser$spaces)),
				$author$project$ScreeptV2$parserExpression),
				A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$ignorer,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$succeed($author$project$ScreeptV2$Proc),
							$elm$parser$Parser$keyword('PROC')),
						$elm$parser$Parser$spaces),
					A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserLiteralIdentifier, $elm$parser$Parser$spaces)),
				$elm$parser$Parser$lazy(
					function (_v3) {
						return $author$project$ScreeptV2$cyclic$parserStatement();
					}))
			]));
}
try {
	var $author$project$ScreeptV2$parserStatement = $author$project$ScreeptV2$cyclic$parserStatement();
	$author$project$ScreeptV2$cyclic$parserStatement = function () {
		return $author$project$ScreeptV2$parserStatement;
	};
} catch ($) {
	throw 'Some top-level definitions from `ScreeptV2` are causing infinite recursion:\n\n  ┌─────┐\n  │    parserStatement\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
var $elm$parser$Parser$DeadEnd = F3(
	function (row, col, problem) {
		return {col: col, problem: problem, row: row};
	});
var $elm$parser$Parser$problemToDeadEnd = function (p) {
	return A3($elm$parser$Parser$DeadEnd, p.row, p.col, p.problem);
};
var $elm$parser$Parser$Advanced$bagToList = F2(
	function (bag, list) {
		bagToList:
		while (true) {
			switch (bag.$) {
				case 'Empty':
					return list;
				case 'AddRight':
					var bag1 = bag.a;
					var x = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$core$List$cons, x, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
				default:
					var bag1 = bag.a;
					var bag2 = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$parser$Parser$Advanced$bagToList, bag2, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
			}
		}
	});
var $elm$parser$Parser$Advanced$run = F2(
	function (_v0, src) {
		var parse = _v0.a;
		var _v1 = parse(
			{col: 1, context: _List_Nil, indent: 1, offset: 0, row: 1, src: src});
		if (_v1.$ === 'Good') {
			var value = _v1.b;
			return $elm$core$Result$Ok(value);
		} else {
			var bag = _v1.b;
			return $elm$core$Result$Err(
				A2($elm$parser$Parser$Advanced$bagToList, bag, _List_Nil));
		}
	});
var $elm$parser$Parser$run = F2(
	function (parser, source) {
		var _v0 = A2($elm$parser$Parser$Advanced$run, parser, source);
		if (_v0.$ === 'Ok') {
			var a = _v0.a;
			return $elm$core$Result$Ok(a);
		} else {
			var problems = _v0.a;
			return $elm$core$Result$Err(
				A2($elm$core$List$map, $elm$parser$Parser$problemToDeadEnd, problems));
		}
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Bitwise$shiftRightBy = _Bitwise_shiftRightBy;
var $elm$core$String$repeatHelp = F3(
	function (n, chunk, result) {
		return (n <= 0) ? result : A3(
			$elm$core$String$repeatHelp,
			n >> 1,
			_Utils_ap(chunk, chunk),
			(!(n & 1)) ? result : _Utils_ap(result, chunk));
	});
var $elm$core$String$repeat = F2(
	function (n, chunk) {
		return A3($elm$core$String$repeatHelp, n, chunk, '');
	});
var $author$project$ScreeptV2$stringifyPrettyStatement = F2(
	function (i, statement) {
		var ident = function (id) {
			return A2($elm$core$String$repeat, id, ' ');
		};
		return _Utils_ap(
			ident(i),
			function () {
				switch (statement.$) {
					case 'Bind':
						var identifier = statement.a;
						var expression = statement.b;
						return $author$project$ScreeptV2$stringifyIdentifier(identifier) + (' = ' + $author$project$ScreeptV2$stringifyExpression(expression));
					case 'Block':
						var statements = statement.a;
						return $elm$core$List$isEmpty(statements) ? '{}' : ('{\n' + (A2(
							$elm$core$String$join,
							';\n',
							A2(
								$elm$core$List$map,
								$author$project$ScreeptV2$stringifyPrettyStatement(i + 1),
								statements)) + ('\n' + (ident(i) + '}'))));
					case 'If':
						var expression = statement.a;
						var success = statement.b;
						var failure = statement.c;
						return 'IF ' + ($author$project$ScreeptV2$stringifyExpression(expression) + (' THEN\n' + (A2($author$project$ScreeptV2$stringifyPrettyStatement, i + 1, success) + ('\n' + (ident(i) + ('ELSE ' + A2($author$project$ScreeptV2$stringifyPrettyStatement, i + 1, failure)))))));
					case 'Print':
						var expression = statement.a;
						return 'PRINT ' + $author$project$ScreeptV2$stringifyExpression(expression);
					case 'RunProc':
						var string = statement.a;
						return 'RUN ' + string;
					case 'Rnd':
						var identifier = statement.a;
						var from = statement.b;
						var to = statement.c;
						return 'RND ' + ($author$project$ScreeptV2$stringifyIdentifier(identifier) + (' ' + ($author$project$ScreeptV2$stringifyExpression(from) + (' ' + $author$project$ScreeptV2$stringifyExpression(to)))));
					default:
						var string = statement.a;
						var procedure = statement.b;
						return 'PROC ' + (string + (' ' + A2($author$project$ScreeptV2$stringifyPrettyStatement, i + 1, procedure)));
				}
			}());
	});
var $elm$core$Result$withDefault = F2(
	function (def, result) {
		if (result.$ === 'Ok') {
			var a = result.a;
			return a;
		} else {
			return def;
		}
	});
var $author$project$ScreeptEditor$init = {
	statementEditor: A3(
		$author$project$ParsedEditable$init,
		A2(
			$elm$core$Result$withDefault,
			$author$project$ScreeptV2$Block(_List_Nil),
			A2($elm$parser$Parser$run, $author$project$ScreeptV2$parserStatement, '{ turn = (turn + 1);  turns_count = (turns_count - 1);  minutes = ((turn %% turns_per_hour) * (60 / turns_per_hour));  hour = ((turn / turns_per_hour) %% 24);  day = (turn / (turns_per_hour * 24)); IF (turns_count > 0) THEN RUN turn ELSE {  turns_count = 5 }; IF (minutes?1:0) THEN {  } ELSE {  }; PROC sub { RND d6 1 6 } }')),
		$author$project$ScreeptV2$parserStatement,
		$author$project$ScreeptV2$stringifyPrettyStatement(0)),
	value: $elm$core$Maybe$Nothing
};
var $mhoare$elm_stack$Stack$Stack = function (a) {
	return {$: 'Stack', a: a};
};
var $mhoare$elm_stack$Stack$initialise = $mhoare$elm_stack$Stack$Stack(_List_Nil);
var $mhoare$elm_stack$Stack$push = F2(
	function (item, _v0) {
		var stack = _v0.a;
		return $mhoare$elm_stack$Stack$Stack(
			A2($elm$core$List$cons, item, stack));
	});
var $author$project$DialogGame$emptyGameState = {
	dialogStack: A2($mhoare$elm_stack$Stack$push, 'start', $mhoare$elm_stack$Stack$initialise),
	messages: _List_Nil,
	screeptEnv: {
		procedures: $elm$core$Dict$empty,
		rnd: $elm$random$Random$initialSeed(666),
		vars: $elm$core$Dict$empty
	}
};
var $author$project$DialogGame$init = F2(
	function (gs, dialogs) {
		return {dialogs: dialogs, gameState: gs};
	});
var $author$project$DialogGame$initSimple = function (dialogs) {
	return A2($author$project$DialogGame$init, $author$project$DialogGame$emptyGameState, dialogs);
};
var $author$project$DialogGame$Exit = function (a) {
	return {$: 'Exit', a: a};
};
var $author$project$DialogGame$GoAction = function (a) {
	return {$: 'GoAction', a: a};
};
var $author$project$DialogGame$GoBackAction = {$: 'GoBackAction'};
var $author$project$DialogGame$goBackOption = {
	actions: _List_fromArray(
		[$author$project$DialogGame$GoBackAction]),
	condition: $elm$core$Maybe$Nothing,
	text: $author$project$ScreeptV2$Literal(
		$author$project$ScreeptV2$Text('Go back'))
};
var $author$project$DialogGame$listDialogToDictDialog = function (dialogs) {
	return $elm$core$Dict$fromList(
		A2(
			$elm$core$List$map,
			function (dial) {
				return _Utils_Tuple2(dial.id, dial);
			},
			dialogs));
};
var $author$project$Main$mainMenuDialogs = $author$project$DialogGame$listDialogToDictDialog(
	_List_fromArray(
		[
			{
			id: 'start',
			options: _List_fromArray(
				[
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$GoAction('load_game_definition')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Load Game'))
				},
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$GoAction('in_game'),
							$author$project$DialogGame$Exit('start_game')
						]),
					condition: $elm$core$Maybe$Just(
						$author$project$ScreeptV2$Variable(
							$author$project$ScreeptV2$LiteralIdentifier('game_loaded'))),
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Start Game'))
				}
				]),
			text: $author$project$ScreeptV2$Literal(
				$author$project$ScreeptV2$Text('Main Menu'))
		},
			{
			id: 'load_game_definition',
			options: _List_fromArray(
				[
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$Exit('sandbox')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Load Sandbox'))
				},
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$Exit('fabled')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Load Fabled Lands'))
				},
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$Exit('load_url')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Load from url'))
				},
					$author$project$DialogGame$goBackOption
				]),
			text: $author$project$ScreeptV2$Literal(
				$author$project$ScreeptV2$Text('Load game definition'))
		},
			{
			id: 'in_game',
			options: _List_fromArray(
				[
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$Exit('start_game')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Restart'))
				},
					{
					actions: _List_fromArray(
						[
							$author$project$DialogGame$GoAction('start'),
							$author$project$DialogGame$Exit('stop_game')
						]),
					condition: $elm$core$Maybe$Nothing,
					text: $author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Stop game'))
				}
				]),
			text: A3(
				$author$project$ScreeptV2$BinaryExpression,
				$author$project$ScreeptV2$Literal(
					$author$project$ScreeptV2$Text('Playing: ')),
				$author$project$ScreeptV2$Add,
				$author$project$ScreeptV2$Variable(
					$author$project$ScreeptV2$LiteralIdentifier('game_title')))
		}
		]));
var $author$project$Main$init = function (_v0) {
	return _Utils_Tuple2(
		{
			dialogEditor: $elm$core$Maybe$Nothing,
			gameDefinition: $elm$core$Maybe$Nothing,
			gameDialog: $author$project$Main$NotLoaded,
			isDebug: true,
			mainMenuDialog: $author$project$DialogGame$initSimple($author$project$Main$mainMenuDialogs),
			screeptEditor: $author$project$ScreeptEditor$init,
			urlLoader: $elm$core$Maybe$Nothing
		},
		$elm$core$Platform$Cmd$batch(
			_List_fromArray(
				[
					A2($elm$random$Random$generate, $author$project$Main$SeedGenerated, $elm$random$Random$independentSeed),
					$author$project$Main$askforGame(_Utils_Tuple0)
				])));
};
var $author$project$ScreeptV2$newScreeptParseExample = A2(
	$elm$parser$Parser$run,
	A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserExpression, $elm$parser$Parser$end),
	'CONCAT(\n"You are on plot ",farm_plot,(${CONCAT("farm_plot_tilled_",farm_plot)}\n?", tilled":", not tilled"))');
var $author$project$ScreeptV2$parseStatementExample = A2(
	$elm$parser$Parser$run,
	A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserStatement, $elm$parser$Parser$end),
	'{ RND b 100 101;\nPRINT CONCAT(add2,t1,t2);\nif = 12; IF 0 THEN PRINT "Y" ELSE PRINT f1();\nfff = FUNC (__1 * __2);\nbbb = fff( 12, 5);\nPROC turn { turn = (turn + 1);\n          turns_count = (turns_count - 1);\n          minutes = ((turn %% turns_per_hour) * (60 / turns_per_hour));\n          hour = ((turn / turns_per_hour) %% 24);\n          day = (turn / (turns_per_hour * 24));\n          IF (turns_count > 0) THEN RUN turn ELSE {turns_count = 5} };\nRUN turn;\nPRINT bbb;\nPRINT (""?3:b) }');
var $author$project$ScreeptV2$exampleStatement = $author$project$ScreeptV2$Block(
	_List_fromArray(
		[
			$author$project$ScreeptV2$Print(
			$author$project$ScreeptV2$Literal(
				$author$project$ScreeptV2$Text('Janek'))),
			A2(
			$author$project$ScreeptV2$Bind,
			$author$project$ScreeptV2$LiteralIdentifier('test2'),
			A3(
				$author$project$ScreeptV2$BinaryExpression,
				$author$project$ScreeptV2$Variable(
					$author$project$ScreeptV2$LiteralIdentifier('int1')),
				$author$project$ScreeptV2$Add,
				$author$project$ScreeptV2$Literal(
					$author$project$ScreeptV2$Number(3)))),
			$author$project$ScreeptV2$Print(
			A2(
				$author$project$ScreeptV2$StandardLibrary,
				'CONCAT',
				_List_fromArray(
					[
						$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Janek')),
						$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Dznanek')),
						$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Text('Janek'))
					]))),
			A3(
			$author$project$ScreeptV2$If,
			$author$project$ScreeptV2$Variable(
				$author$project$ScreeptV2$LiteralIdentifier('int1')),
			$author$project$ScreeptV2$Print(
				$author$project$ScreeptV2$Literal(
					$author$project$ScreeptV2$Text('Yes'))),
			$author$project$ScreeptV2$Print(
				$author$project$ScreeptV2$Literal(
					$author$project$ScreeptV2$Text('No')))),
			$author$project$ScreeptV2$Print(
			A2(
				$author$project$ScreeptV2$FunctionCall,
				$author$project$ScreeptV2$LiteralIdentifier('add2'),
				_List_fromArray(
					[
						$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Number(5)),
						$author$project$ScreeptV2$Literal(
						$author$project$ScreeptV2$Number(6))
					])))
		]));
var $author$project$ScreeptV2$runExample = A2(
	$author$project$ScreeptV2$executeStatement,
	$author$project$ScreeptV2$exampleStatement,
	_Utils_Tuple2($author$project$ScreeptV2$exampleScreeptState, _List_Nil));
var $elm$http$Http$BadBody = function (a) {
	return {$: 'BadBody', a: a};
};
var $author$project$Main$GotGameDefinition = function (a) {
	return {$: 'GotGameDefinition', a: a};
};
var $author$project$DialogGame$GameDefinition = F5(
	function (title, dialogs, startDialogId, procedures, vars) {
		return {dialogs: dialogs, procedures: procedures, startDialogId: startDialogId, title: title, vars: vars};
	});
var $author$project$DialogGame$Dialog = F3(
	function (id, text, options) {
		return {id: id, options: options, text: text};
	});
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$ScreeptV2$parserToDecoder = function (parser) {
	var parseResultToDecoder = function (v) {
		if (v.$ === 'Err') {
			return $elm$json$Json$Decode$fail('fail to decode expression');
		} else {
			var expr = v.a;
			return $elm$json$Json$Decode$succeed(expr);
		}
	};
	return A2(
		$elm$json$Json$Decode$andThen,
		A2(
			$elm$core$Basics$composeR,
			$elm$parser$Parser$run(parser),
			parseResultToDecoder),
		$elm$json$Json$Decode$string);
};
var $author$project$ScreeptV2$decodeExpression = $author$project$ScreeptV2$parserToDecoder(
	A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserExpression, $elm$parser$Parser$end));
var $author$project$DialogGame$DialogOption = F3(
	function (text, condition, actions) {
		return {actions: actions, condition: condition, text: text};
	});
var $author$project$DialogGame$ActionBlock = function (a) {
	return {$: 'ActionBlock', a: a};
};
var $author$project$DialogGame$ConditionalAction = F3(
	function (a, b, c) {
		return {$: 'ConditionalAction', a: a, b: b, c: c};
	});
var $author$project$DialogGame$Message = function (a) {
	return {$: 'Message', a: a};
};
var $author$project$DialogGame$Screept = function (a) {
	return {$: 'Screept', a: a};
};
var $author$project$ScreeptV2$decodeStatement = $author$project$ScreeptV2$parserToDecoder(
	A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserStatement, $elm$parser$Parser$end));
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$lazy = function (thunk) {
	return A2(
		$elm$json$Json$Decode$andThen,
		thunk,
		$elm$json$Json$Decode$succeed(_Utils_Tuple0));
};
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$map3 = _Json_map3;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
function $author$project$DialogGame$cyclic$decodeAction() {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$json$Json$Decode$map,
				$author$project$DialogGame$GoAction,
				A2($elm$json$Json$Decode$field, 'go_dialog', $elm$json$Json$Decode$string)),
				A2(
				$elm$json$Json$Decode$andThen,
				function (x) {
					return (x === 'go_back') ? $elm$json$Json$Decode$succeed($author$project$DialogGame$GoBackAction) : $elm$json$Json$Decode$fail('');
				},
				$elm$json$Json$Decode$string),
				A2(
				$elm$json$Json$Decode$map,
				$author$project$DialogGame$Message,
				A2($elm$json$Json$Decode$field, 'msg', $author$project$ScreeptV2$decodeExpression)),
				A2(
				$elm$json$Json$Decode$map,
				$author$project$DialogGame$Screept,
				A2($elm$json$Json$Decode$field, 'screept', $author$project$ScreeptV2$decodeStatement)),
				A4(
				$elm$json$Json$Decode$map3,
				$author$project$DialogGame$ConditionalAction,
				A2($elm$json$Json$Decode$field, 'if', $author$project$ScreeptV2$decodeExpression),
				A2(
					$elm$json$Json$Decode$field,
					'then',
					$elm$json$Json$Decode$lazy(
						function (_v0) {
							return $author$project$DialogGame$cyclic$decodeAction();
						})),
				A2(
					$elm$json$Json$Decode$field,
					'else',
					$elm$json$Json$Decode$lazy(
						function (_v1) {
							return $author$project$DialogGame$cyclic$decodeAction();
						}))),
				A2(
				$elm$json$Json$Decode$map,
				$author$project$DialogGame$ActionBlock,
				$elm$json$Json$Decode$list(
					$elm$json$Json$Decode$lazy(
						function (_v2) {
							return $author$project$DialogGame$cyclic$decodeAction();
						})))
			]));
}
try {
	var $author$project$DialogGame$decodeAction = $author$project$DialogGame$cyclic$decodeAction();
	$author$project$DialogGame$cyclic$decodeAction = function () {
		return $author$project$DialogGame$decodeAction;
	};
} catch ($) {
	throw 'Some top-level definitions from `DialogGame` are causing infinite recursion:\n\n  ┌─────┐\n  │    decodeAction\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
var $elm$json$Json$Decode$maybe = function (decoder) {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2($elm$json$Json$Decode$map, $elm$core$Maybe$Just, decoder),
				$elm$json$Json$Decode$succeed($elm$core$Maybe$Nothing)
			]));
};
var $author$project$DialogGame$decodeOption = A4(
	$elm$json$Json$Decode$map3,
	$author$project$DialogGame$DialogOption,
	A2($elm$json$Json$Decode$field, 'text', $author$project$ScreeptV2$decodeExpression),
	$elm$json$Json$Decode$maybe(
		A2($elm$json$Json$Decode$field, 'condition', $author$project$ScreeptV2$decodeExpression)),
	A2(
		$elm$json$Json$Decode$field,
		'action',
		$elm$json$Json$Decode$list($author$project$DialogGame$decodeAction)));
var $author$project$DialogGame$decodeDialog = A4(
	$elm$json$Json$Decode$map3,
	$author$project$DialogGame$Dialog,
	A2($elm$json$Json$Decode$field, 'id', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'text', $author$project$ScreeptV2$decodeExpression),
	A2(
		$elm$json$Json$Decode$field,
		'options',
		$elm$json$Json$Decode$list($author$project$DialogGame$decodeOption)));
var $author$project$DialogGame$decodeDialogs = $elm$json$Json$Decode$list($author$project$DialogGame$decodeDialog);
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $author$project$ScreeptV2$decodeValue = function () {
	var stringToValueParser = function (s) {
		var _v0 = A2($elm$parser$Parser$run, $author$project$ScreeptV2$parserExpression, s);
		if (_v0.$ === 'Ok') {
			var expr = _v0.a;
			return $elm$json$Json$Decode$succeed(
				$author$project$ScreeptV2$Func(expr));
		} else {
			var e = _v0.a;
			return $elm$json$Json$Decode$fail('error decoding Func \'' + (s + '\'.'));
		}
	};
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2($elm$json$Json$Decode$map, $author$project$ScreeptV2$Number, $elm$json$Json$Decode$float),
				A2($elm$json$Json$Decode$map, $author$project$ScreeptV2$Text, $elm$json$Json$Decode$string),
				A2(
				$elm$json$Json$Decode$andThen,
				stringToValueParser,
				A2($elm$json$Json$Decode$field, 'func', $elm$json$Json$Decode$string))
			]));
}();
var $elm$json$Json$Decode$keyValuePairs = _Json_decodeKeyValuePairs;
var $elm$json$Json$Decode$dict = function (decoder) {
	return A2(
		$elm$json$Json$Decode$map,
		$elm$core$Dict$fromList,
		$elm$json$Json$Decode$keyValuePairs(decoder));
};
var $elm$json$Json$Decode$map5 = _Json_map5;
var $author$project$DialogGame$decodeGameDefinition = A6(
	$elm$json$Json$Decode$map5,
	$author$project$DialogGame$GameDefinition,
	A2($elm$json$Json$Decode$field, 'name', $elm$json$Json$Decode$string),
	A2($elm$json$Json$Decode$field, 'dialogs', $author$project$DialogGame$decodeDialogs),
	A2($elm$json$Json$Decode$field, 'startDialogId', $elm$json$Json$Decode$string),
	A2(
		$elm$json$Json$Decode$field,
		'procedures',
		A2(
			$elm$json$Json$Decode$map,
			$elm$core$Dict$toList,
			$elm$json$Json$Decode$dict($author$project$ScreeptV2$decodeStatement))),
	A2(
		$elm$json$Json$Decode$field,
		'vars',
		$elm$json$Json$Decode$dict($author$project$ScreeptV2$decodeValue)));
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $author$project$Main$loadGame = _Platform_incomingPort('loadGame', $elm$json$Json$Decode$string);
var $elm$core$Result$mapError = F2(
	function (f, result) {
		if (result.$ === 'Ok') {
			var v = result.a;
			return $elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return $elm$core$Result$Err(
				f(e));
		}
	});
var $author$project$Main$subscriptions = function (model) {
	return $author$project$Main$loadGame(
		function (s) {
			return $author$project$Main$GotGameDefinition(
				A2(
					$elm$core$Result$mapError,
					$elm$core$Basics$always(
						$elm$http$Http$BadBody('bad body')),
					A2($elm$json$Json$Decode$decodeString, $author$project$DialogGame$decodeGameDefinition, s)));
		});
};
var $author$project$Main$Loaded = function (a) {
	return {$: 'Loaded', a: a};
};
var $author$project$Main$Started = F2(
	function (a, b) {
		return {$: 'Started', a: a, b: b};
	});
var $author$project$ScreeptV2$executeStringStatement = F2(
	function (statementString, _var) {
		var _v0 = A2(
			$elm$parser$Parser$run,
			A2($elm$parser$Parser$ignorer, $author$project$ScreeptV2$parserStatement, $elm$parser$Parser$end),
			statementString);
		if (_v0.$ === 'Ok') {
			var statement = _v0.a;
			return A2(
				$elm$core$Result$withDefault,
				_Utils_Tuple2(_var, _List_Nil),
				A2(
					$author$project$ScreeptV2$executeStatement,
					statement,
					_Utils_Tuple2(_var, _List_Nil)));
		} else {
			return _Utils_Tuple2(_var, _List_Nil);
		}
	});
var $elm$http$Http$BadStatus_ = F2(
	function (a, b) {
		return {$: 'BadStatus_', a: a, b: b};
	});
var $elm$http$Http$BadUrl_ = function (a) {
	return {$: 'BadUrl_', a: a};
};
var $elm$http$Http$GoodStatus_ = F2(
	function (a, b) {
		return {$: 'GoodStatus_', a: a, b: b};
	});
var $elm$http$Http$NetworkError_ = {$: 'NetworkError_'};
var $elm$http$Http$Receiving = function (a) {
	return {$: 'Receiving', a: a};
};
var $elm$http$Http$Sending = function (a) {
	return {$: 'Sending', a: a};
};
var $elm$http$Http$Timeout_ = {$: 'Timeout_'};
var $elm$core$Maybe$isJust = function (maybe) {
	if (maybe.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (_v0.$ === 'Just') {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$http$Http$expectStringResponse = F2(
	function (toMsg, toResult) {
		return A3(
			_Http_expect,
			'',
			$elm$core$Basics$identity,
			A2($elm$core$Basics$composeR, toResult, toMsg));
	});
var $elm$http$Http$BadStatus = function (a) {
	return {$: 'BadStatus', a: a};
};
var $elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var $elm$http$Http$NetworkError = {$: 'NetworkError'};
var $elm$http$Http$Timeout = {$: 'Timeout'};
var $elm$http$Http$resolve = F2(
	function (toResult, response) {
		switch (response.$) {
			case 'BadUrl_':
				var url = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadUrl(url));
			case 'Timeout_':
				return $elm$core$Result$Err($elm$http$Http$Timeout);
			case 'NetworkError_':
				return $elm$core$Result$Err($elm$http$Http$NetworkError);
			case 'BadStatus_':
				var metadata = response.a;
				return $elm$core$Result$Err(
					$elm$http$Http$BadStatus(metadata.statusCode));
			default:
				var body = response.b;
				return A2(
					$elm$core$Result$mapError,
					$elm$http$Http$BadBody,
					toResult(body));
		}
	});
var $elm$http$Http$expectJson = F2(
	function (toMsg, decoder) {
		return A2(
			$elm$http$Http$expectStringResponse,
			toMsg,
			$elm$http$Http$resolve(
				function (string) {
					return A2(
						$elm$core$Result$mapError,
						$elm$json$Json$Decode$errorToString,
						A2($elm$json$Json$Decode$decodeString, decoder, string));
				}));
	});
var $elm$http$Http$emptyBody = _Http_emptyBody;
var $elm$http$Http$Request = function (a) {
	return {$: 'Request', a: a};
};
var $elm$http$Http$State = F2(
	function (reqs, subs) {
		return {reqs: reqs, subs: subs};
	});
var $elm$http$Http$init = $elm$core$Task$succeed(
	A2($elm$http$Http$State, $elm$core$Dict$empty, _List_Nil));
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$http$Http$updateReqs = F3(
	function (router, cmds, reqs) {
		updateReqs:
		while (true) {
			if (!cmds.b) {
				return $elm$core$Task$succeed(reqs);
			} else {
				var cmd = cmds.a;
				var otherCmds = cmds.b;
				if (cmd.$ === 'Cancel') {
					var tracker = cmd.a;
					var _v2 = A2($elm$core$Dict$get, tracker, reqs);
					if (_v2.$ === 'Nothing') {
						var $temp$router = router,
							$temp$cmds = otherCmds,
							$temp$reqs = reqs;
						router = $temp$router;
						cmds = $temp$cmds;
						reqs = $temp$reqs;
						continue updateReqs;
					} else {
						var pid = _v2.a;
						return A2(
							$elm$core$Task$andThen,
							function (_v3) {
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A2($elm$core$Dict$remove, tracker, reqs));
							},
							$elm$core$Process$kill(pid));
					}
				} else {
					var req = cmd.a;
					return A2(
						$elm$core$Task$andThen,
						function (pid) {
							var _v4 = req.tracker;
							if (_v4.$ === 'Nothing') {
								return A3($elm$http$Http$updateReqs, router, otherCmds, reqs);
							} else {
								var tracker = _v4.a;
								return A3(
									$elm$http$Http$updateReqs,
									router,
									otherCmds,
									A3($elm$core$Dict$insert, tracker, pid, reqs));
							}
						},
						$elm$core$Process$spawn(
							A3(
								_Http_toTask,
								router,
								$elm$core$Platform$sendToApp(router),
								req)));
				}
			}
		}
	});
var $elm$http$Http$onEffects = F4(
	function (router, cmds, subs, state) {
		return A2(
			$elm$core$Task$andThen,
			function (reqs) {
				return $elm$core$Task$succeed(
					A2($elm$http$Http$State, reqs, subs));
			},
			A3($elm$http$Http$updateReqs, router, cmds, state.reqs));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$http$Http$maybeSend = F4(
	function (router, desiredTracker, progress, _v0) {
		var actualTracker = _v0.a;
		var toMsg = _v0.b;
		return _Utils_eq(desiredTracker, actualTracker) ? $elm$core$Maybe$Just(
			A2(
				$elm$core$Platform$sendToApp,
				router,
				toMsg(progress))) : $elm$core$Maybe$Nothing;
	});
var $elm$http$Http$onSelfMsg = F3(
	function (router, _v0, state) {
		var tracker = _v0.a;
		var progress = _v0.b;
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$filterMap,
					A3($elm$http$Http$maybeSend, router, tracker, progress),
					state.subs)));
	});
var $elm$http$Http$Cancel = function (a) {
	return {$: 'Cancel', a: a};
};
var $elm$http$Http$cmdMap = F2(
	function (func, cmd) {
		if (cmd.$ === 'Cancel') {
			var tracker = cmd.a;
			return $elm$http$Http$Cancel(tracker);
		} else {
			var r = cmd.a;
			return $elm$http$Http$Request(
				{
					allowCookiesFromOtherDomains: r.allowCookiesFromOtherDomains,
					body: r.body,
					expect: A2(_Http_mapExpect, func, r.expect),
					headers: r.headers,
					method: r.method,
					timeout: r.timeout,
					tracker: r.tracker,
					url: r.url
				});
		}
	});
var $elm$http$Http$MySub = F2(
	function (a, b) {
		return {$: 'MySub', a: a, b: b};
	});
var $elm$http$Http$subMap = F2(
	function (func, _v0) {
		var tracker = _v0.a;
		var toMsg = _v0.b;
		return A2(
			$elm$http$Http$MySub,
			tracker,
			A2($elm$core$Basics$composeR, toMsg, func));
	});
_Platform_effectManagers['Http'] = _Platform_createManager($elm$http$Http$init, $elm$http$Http$onEffects, $elm$http$Http$onSelfMsg, $elm$http$Http$cmdMap, $elm$http$Http$subMap);
var $elm$http$Http$command = _Platform_leaf('Http');
var $elm$http$Http$subscription = _Platform_leaf('Http');
var $elm$http$Http$request = function (r) {
	return $elm$http$Http$command(
		$elm$http$Http$Request(
			{allowCookiesFromOtherDomains: false, body: r.body, expect: r.expect, headers: r.headers, method: r.method, timeout: r.timeout, tracker: r.tracker, url: r.url}));
};
var $elm$http$Http$get = function (r) {
	return $elm$http$Http$request(
		{body: $elm$http$Http$emptyBody, expect: r.expect, headers: _List_Nil, method: 'GET', timeout: $elm$core$Maybe$Nothing, tracker: $elm$core$Maybe$Nothing, url: r.url});
};
var $author$project$DialogGameEditor$init = function (gd) {
	return {editedDialog: $elm$core$Maybe$Nothing, editedProcedure: $elm$core$Maybe$Nothing, gameDefinition: gd};
};
var $author$project$Main$initGameFromGameDefinition = function (gameDefinition) {
	return {
		dialogs: $author$project$DialogGame$listDialogToDictDialog(gameDefinition.dialogs),
		gameState: {
			dialogStack: A2($mhoare$elm_stack$Stack$push, gameDefinition.startDialogId, $mhoare$elm_stack$Stack$initialise),
			messages: _List_Nil,
			screeptEnv: {
				procedures: $elm$core$Dict$fromList(gameDefinition.procedures),
				rnd: $elm$random$Random$initialSeed(666),
				vars: gameDefinition.vars
			}
		}
	};
};
var $author$project$Main$ShowUrlLoader = {$: 'ShowUrlLoader'};
var $author$project$Main$StartGame = {$: 'StartGame'};
var $author$project$Main$StopGame = {$: 'StopGame'};
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$Main$mainMenuActions = F2(
	function (dialModel, mcode) {
		if (mcode.$ === 'Nothing') {
			return _Utils_Tuple2(dialModel, $elm$core$Platform$Cmd$none);
		} else {
			var code = mcode.a;
			switch (code) {
				case 'sandbox':
					return _Utils_Tuple2(
						dialModel,
						$elm$http$Http$get(
							{
								expect: A2($elm$http$Http$expectJson, $author$project$Main$GotGameDefinition, $author$project$DialogGame$decodeGameDefinition),
								url: 'games/testsandbox.json'
							}));
				case 'fabled':
					return _Utils_Tuple2(
						dialModel,
						$elm$http$Http$get(
							{
								expect: A2($elm$http$Http$expectJson, $author$project$Main$GotGameDefinition, $author$project$DialogGame$decodeGameDefinition),
								url: 'games/fabled.json'
							}));
				case 'start_game':
					return _Utils_Tuple2(
						dialModel,
						A2(
							$elm$core$Task$perform,
							$elm$core$Basics$identity,
							$elm$core$Task$succeed($author$project$Main$StartGame)));
				case 'stop_game':
					return _Utils_Tuple2(
						dialModel,
						A2(
							$elm$core$Task$perform,
							$elm$core$Basics$identity,
							$elm$core$Task$succeed($author$project$Main$StopGame)));
				case 'load_url':
					return _Utils_Tuple2(
						dialModel,
						A2(
							$elm$core$Task$perform,
							$elm$core$Basics$identity,
							$elm$core$Task$succeed($author$project$Main$ShowUrlLoader)));
				default:
					return _Utils_Tuple2(dialModel, $elm$core$Platform$Cmd$none);
			}
		}
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Main$saveGame = _Platform_outgoingPort('saveGame', $elm$json$Json$Encode$string);
var $author$project$DialogGame$setRndSeed = F2(
	function (seed, model) {
		var gameState = model.gameState;
		var screeptEnv = gameState.screeptEnv;
		return _Utils_update(
			model,
			{
				gameState: _Utils_update(
					gameState,
					{
						screeptEnv: _Utils_update(
							screeptEnv,
							{rnd: seed})
					})
			});
	});
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$json$Json$Encode$dict = F3(
	function (toKey, toValue, dictionary) {
		return _Json_wrap(
			A3(
				$elm$core$Dict$foldl,
				F3(
					function (key, value, obj) {
						return A3(
							_Json_addField,
							toKey(key),
							toValue(value),
							obj);
					}),
				_Json_emptyObject(_Utils_Tuple0),
				dictionary));
	});
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $author$project$ScreeptV2$stringifyStatement = function (statement) {
	return A2($author$project$ScreeptV2$stringifyPrettyStatement, 0, statement);
};
var $author$project$DialogGame$encodeDialogAction = function (dialogAction) {
	switch (dialogAction.$) {
		case 'GoAction':
			var dialogId = dialogAction.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'go_dialog',
						$elm$json$Json$Encode$string(dialogId))
					]));
		case 'GoBackAction':
			return $elm$json$Json$Encode$string('go_back');
		case 'Message':
			var expression = dialogAction.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'msg',
						$elm$json$Json$Encode$string(
							$author$project$ScreeptV2$stringifyExpression(expression)))
					]));
		case 'Screept':
			var statement = dialogAction.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'screept',
						$elm$json$Json$Encode$string(
							$author$project$ScreeptV2$stringifyStatement(statement)))
					]));
		case 'ConditionalAction':
			var condition = dialogAction.a;
			var success = dialogAction.b;
			var failure = dialogAction.c;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'if',
						$elm$json$Json$Encode$string(
							$author$project$ScreeptV2$stringifyExpression(condition))),
						_Utils_Tuple2(
						'then',
						$author$project$DialogGame$encodeDialogAction(success)),
						_Utils_Tuple2(
						'else',
						$author$project$DialogGame$encodeDialogAction(failure))
					]));
		case 'ActionBlock':
			var dialogActions = dialogAction.a;
			return A2($elm$json$Json$Encode$list, $author$project$DialogGame$encodeDialogAction, dialogActions);
		default:
			var s = dialogAction.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'exit',
						$elm$json$Json$Encode$string(s))
					]));
	}
};
var $author$project$DialogGame$encodeDialogOption = function (_v0) {
	var text = _v0.text;
	var condition = _v0.condition;
	var actions = _v0.actions;
	return $elm$json$Json$Encode$object(
		_Utils_ap(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'text',
					$elm$json$Json$Encode$string(
						$author$project$ScreeptV2$stringifyExpression(text))),
					_Utils_Tuple2(
					'action',
					A2($elm$json$Json$Encode$list, $author$project$DialogGame$encodeDialogAction, actions))
				]),
			function () {
				if (condition.$ === 'Just') {
					var a = condition.a;
					return _List_fromArray(
						[
							_Utils_Tuple2(
							'condition',
							$elm$json$Json$Encode$string(
								$author$project$ScreeptV2$stringifyExpression(a)))
						]);
				} else {
					return _List_Nil;
				}
			}()));
};
var $author$project$DialogGame$encodeDialog = function (_v0) {
	var id = _v0.id;
	var text = _v0.text;
	var options = _v0.options;
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				$elm$json$Json$Encode$string(id)),
				_Utils_Tuple2(
				'text',
				$elm$json$Json$Encode$string(
					$author$project$ScreeptV2$stringifyExpression(text))),
				_Utils_Tuple2(
				'options',
				A2($elm$json$Json$Encode$list, $author$project$DialogGame$encodeDialogOption, options))
			]));
};
var $elm$json$Json$Encode$float = _Json_wrap;
var $author$project$ScreeptV2$encodeValue = function (value) {
	switch (value.$) {
		case 'Number':
			var _float = value.a;
			return $elm$json$Json$Encode$float(_float);
		case 'Text':
			var string = value.a;
			return $elm$json$Json$Encode$string(string);
		default:
			var expression = value.a;
			return $elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'func',
						$elm$json$Json$Encode$string(
							$author$project$ScreeptV2$stringifyExpression(expression)))
					]));
	}
};
var $author$project$DialogGame$encodeGameDefinition = function (_v0) {
	var title = _v0.title;
	var dialogs = _v0.dialogs;
	var startDialogId = _v0.startDialogId;
	var vars = _v0.vars;
	var procedures = _v0.procedures;
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'name',
				$elm$json$Json$Encode$string(title)),
				_Utils_Tuple2(
				'dialogs',
				A2($elm$json$Json$Encode$list, $author$project$DialogGame$encodeDialog, dialogs)),
				_Utils_Tuple2(
				'startDialogId',
				$elm$json$Json$Encode$string(startDialogId)),
				_Utils_Tuple2(
				'procedures',
				A3(
					$elm$json$Json$Encode$dict,
					$elm$core$Basics$identity,
					A2($elm$core$Basics$composeR, $author$project$ScreeptV2$stringifyStatement, $elm$json$Json$Encode$string),
					$elm$core$Dict$fromList(procedures))),
				_Utils_Tuple2(
				'vars',
				A3($elm$json$Json$Encode$dict, $elm$core$Basics$identity, $author$project$ScreeptV2$encodeValue, vars))
			]));
};
var $author$project$DialogGame$stringifyGameDefinition = function (gd) {
	return A2(
		$elm$json$Json$Encode$encode,
		2,
		$author$project$DialogGame$encodeGameDefinition(gd));
};
var $mhoare$elm_stack$Stack$pop = function (_v0) {
	var stack = _v0.a;
	if (!stack.b) {
		return _Utils_Tuple2(
			$elm$core$Maybe$Nothing,
			$mhoare$elm_stack$Stack$Stack(_List_Nil));
	} else {
		var head = stack.a;
		var tail = stack.b;
		return _Utils_Tuple2(
			$elm$core$Maybe$Just(head),
			$mhoare$elm_stack$Stack$Stack(tail));
	}
};
var $author$project$ScreeptV2$resolveExpressionToString = F2(
	function (env, expression) {
		return A2(
			$elm$core$Result$withDefault,
			'',
			A2(
				$elm$core$Result$map,
				$author$project$ScreeptV2$getStringFromValue,
				A2($author$project$ScreeptV2$evaluateExpression, env, expression)));
	});
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $author$project$DialogGame$executeAction = F2(
	function (dialogActionExecution, gameState) {
		executeAction:
		while (true) {
			switch (dialogActionExecution.$) {
				case 'GoAction':
					var dialogId = dialogActionExecution.a;
					return _Utils_Tuple2(
						_Utils_update(
							gameState,
							{
								dialogStack: A2($mhoare$elm_stack$Stack$push, dialogId, gameState.dialogStack)
							}),
						$elm$core$Maybe$Nothing);
				case 'GoBackAction':
					return _Utils_Tuple2(
						_Utils_update(
							gameState,
							{
								dialogStack: $mhoare$elm_stack$Stack$pop(gameState.dialogStack).b
							}),
						$elm$core$Maybe$Nothing);
				case 'Message':
					var msg = dialogActionExecution.a;
					return _Utils_Tuple2(
						_Utils_update(
							gameState,
							{
								messages: A2(
									$elm$core$List$cons,
									A2($author$project$ScreeptV2$resolveExpressionToString, gameState.screeptEnv, msg),
									gameState.messages)
							}),
						$elm$core$Maybe$Nothing);
				case 'Screept':
					var statement = dialogActionExecution.a;
					var newScreeptEnv = function () {
						var _v1 = A2(
							$author$project$ScreeptV2$executeStatement,
							statement,
							_Utils_Tuple2(gameState.screeptEnv, _List_Nil));
						if (_v1.$ === 'Ok') {
							var _v2 = _v1.a;
							var s = _v2.a;
							return s;
						} else {
							var e = _v1.a;
							var _v3 = A2($elm$core$Debug$log, 'SCREEPT_STATEMENT_ERROR', e);
							return gameState.screeptEnv;
						}
					}();
					return _Utils_Tuple2(
						_Utils_update(
							gameState,
							{screeptEnv: newScreeptEnv}),
						$elm$core$Maybe$Nothing);
				case 'ConditionalAction':
					var condition = dialogActionExecution.a;
					var success = dialogActionExecution.b;
					var failure = dialogActionExecution.c;
					var isConditionMet = A2(
						$elm$core$Result$withDefault,
						false,
						A2(
							$elm$core$Result$map,
							$author$project$ScreeptV2$isTruthy,
							A2($author$project$ScreeptV2$evaluateExpression, gameState.screeptEnv, condition)));
					var $temp$dialogActionExecution = isConditionMet ? success : failure,
						$temp$gameState = gameState;
					dialogActionExecution = $temp$dialogActionExecution;
					gameState = $temp$gameState;
					continue executeAction;
				case 'ActionBlock':
					var dialogActionExecutions = dialogActionExecution.a;
					return A3(
						$elm$core$List$foldl,
						F2(
							function (a, _v4) {
								var state = _v4.a;
								return A2($author$project$DialogGame$executeAction, a, state);
							}),
						_Utils_Tuple2(gameState, $elm$core$Maybe$Nothing),
						dialogActionExecutions);
				default:
					var code = dialogActionExecution.a;
					return _Utils_Tuple2(
						gameState,
						$elm$core$Maybe$Just(code));
			}
		}
	});
var $author$project$DialogGame$update = F2(
	function (msg, model) {
		var actions = msg.a;
		var _v1 = A3(
			$elm$core$List$foldl,
			F2(
				function (a, _v2) {
					var state = _v2.a;
					return A2($author$project$DialogGame$executeAction, a, state);
				}),
			_Utils_Tuple2(model.gameState, $elm$core$Maybe$Nothing),
			actions);
		var gs = _v1.a;
		var code = _v1.b;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{gameState: gs}),
			code);
	});
var $elm$core$Result$toMaybe = function (result) {
	if (result.$ === 'Ok') {
		var v = result.a;
		return $elm$core$Maybe$Just(v);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$ParsedEditable$model_new = {
	getOption: function (m) {
		return $elm$core$Result$toMaybe(m._new);
	},
	set: F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					_new: $elm$core$Result$Ok(s)
				});
		})
};
var $author$project$DialogGameEditor$editedDialogToDialog = function (editableDialog) {
	var _v0 = $author$project$ParsedEditable$model_new.getOption(editableDialog.text);
	if (_v0.$ === 'Just') {
		var text = _v0.a;
		return {id: editableDialog.id, options: editableDialog.options, text: text};
	} else {
		return editableDialog.oldValue;
	}
};
var $author$project$ParsedEditable$current = function (model) {
	return A2($elm$core$Result$withDefault, model.old, model._new);
};
var $author$project$DialogGameEditor$editedProcedureToProcedure = function (editedValue) {
	return _Utils_Tuple2(
		editedValue.name,
		$author$project$ParsedEditable$current(editedValue.definition));
};
var $elm_community$list_extra$List$Extra$find = F2(
	function (predicate, list) {
		find:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var first = list.a;
				var rest = list.b;
				if (predicate(first)) {
					return $elm$core$Maybe$Just(first);
				} else {
					var $temp$predicate = predicate,
						$temp$list = rest;
					predicate = $temp$predicate;
					list = $temp$list;
					continue find;
				}
			}
		}
	});
var $arturopala$elm_monocle$Monocle$Lens$Lens = F2(
	function (get, set) {
		return {get: get, set: set};
	});
var $arturopala$elm_monocle$Monocle$Lens$compose = F2(
	function (outer, inner) {
		var set = F2(
			function (c, a) {
				return function (b) {
					return A2(outer.set, b, a);
				}(
					A2(
						inner.set,
						c,
						outer.get(a)));
			});
		return A2(
			$arturopala$elm_monocle$Monocle$Lens$Lens,
			A2($elm$core$Basics$composeR, outer.get, inner.get),
			set);
	});
var $arturopala$elm_monocle$Monocle$Compose$lensWithLens = F2(
	function (inner, outer) {
		return A2($arturopala$elm_monocle$Monocle$Lens$compose, outer, inner);
	});
var $author$project$Shared$lens_editedProcedure = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.editedProcedure;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{editedProcedure: s});
		}));
var $author$project$Shared$lens_oldValue = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.oldValue;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{oldValue: s});
		}));
var $author$project$DialogGameEditor$lens_procedures = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.procedures;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{procedures: s});
		}));
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $elm_community$list_extra$List$Extra$splitAt = F2(
	function (n, xs) {
		return _Utils_Tuple2(
			A2($elm$core$List$take, n, xs),
			A2($elm$core$List$drop, n, xs));
	});
var $author$project$Shared$insertAt = F3(
	function (index, item, items) {
		var _v0 = A2($elm_community$list_extra$List$Extra$splitAt, index, items);
		var start = _v0.a;
		var end = _v0.b;
		return _Utils_ap(
			start,
			_Utils_ap(
				_List_fromArray(
					[item]),
				end));
	});
var $elm_community$list_extra$List$Extra$removeAt = F2(
	function (index, l) {
		if (index < 0) {
			return l;
		} else {
			var _v0 = A2($elm$core$List$drop, index, l);
			if (!_v0.b) {
				return l;
			} else {
				var rest = _v0.b;
				return _Utils_ap(
					A2($elm$core$List$take, index, l),
					rest);
			}
		}
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm_community$list_extra$List$Extra$uncons = function (list) {
	if (!list.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var first = list.a;
		var rest = list.b;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(first, rest));
	}
};
var $elm_community$list_extra$List$Extra$swapAt = F3(
	function (index1, index2, l) {
		swapAt:
		while (true) {
			if (_Utils_eq(index1, index2) || (index1 < 0)) {
				return l;
			} else {
				if (_Utils_cmp(index1, index2) > 0) {
					var $temp$index1 = index2,
						$temp$index2 = index1,
						$temp$l = l;
					index1 = $temp$index1;
					index2 = $temp$index2;
					l = $temp$l;
					continue swapAt;
				} else {
					var _v0 = A2($elm_community$list_extra$List$Extra$splitAt, index1, l);
					var part1 = _v0.a;
					var tail1 = _v0.b;
					var _v1 = A2($elm_community$list_extra$List$Extra$splitAt, index2 - index1, tail1);
					var head2 = _v1.a;
					var tail2 = _v1.b;
					var _v2 = _Utils_Tuple2(
						$elm_community$list_extra$List$Extra$uncons(head2),
						$elm_community$list_extra$List$Extra$uncons(tail2));
					if ((_v2.a.$ === 'Just') && (_v2.b.$ === 'Just')) {
						var _v3 = _v2.a.a;
						var value1 = _v3.a;
						var part2 = _v3.b;
						var _v4 = _v2.b.a;
						var value2 = _v4.a;
						var part3 = _v4.b;
						return $elm$core$List$concat(
							_List_fromArray(
								[
									part1,
									A2($elm$core$List$cons, value2, part2),
									A2($elm$core$List$cons, value1, part3)
								]));
					} else {
						return l;
					}
				}
			}
		}
	});
var $author$project$Shared$manipulatePositionUpdate = F3(
	function (newObject, msg, list) {
		switch (msg.$) {
			case 'MovePosition':
				var index = msg.a;
				var step = msg.b;
				return A3($elm_community$list_extra$List$Extra$swapAt, index, index + step, list);
			case 'DeletePosition':
				var i = msg.a;
				return A2($elm_community$list_extra$List$Extra$removeAt, i, list);
			default:
				var i = msg.a;
				return A3($author$project$Shared$insertAt, i, newObject, list);
		}
	});
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $author$project$DialogGameEditor$model_gameDefinition = {
	get: function ($) {
		return $.gameDefinition;
	},
	set: F2(
		function (s, m) {
			return _Utils_update(
				m,
				{gameDefinition: s});
		})
};
var $author$project$DialogGameEditor$model_dialogs = A2(
	$arturopala$elm_monocle$Monocle$Compose$lensWithLens,
	A2(
		$arturopala$elm_monocle$Monocle$Lens$Lens,
		function ($) {
			return $.dialogs;
		},
		F2(
			function (s, m) {
				return _Utils_update(
					m,
					{dialogs: s});
			})),
	$author$project$DialogGameEditor$model_gameDefinition);
var $author$project$DialogGameEditor$model_editedDialog = {
	getOption: function ($) {
		return $.editedDialog;
	},
	set: F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					editedDialog: $elm$core$Maybe$Just(s)
				});
		})
};
var $arturopala$elm_monocle$Monocle$Optional$Optional = F2(
	function (getOption, set) {
		return {getOption: getOption, set: set};
	});
var $author$project$DialogGameEditor$model_editedProcedure = A2(
	$arturopala$elm_monocle$Monocle$Optional$Optional,
	function ($) {
		return $.editedProcedure;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					editedProcedure: $elm$core$Maybe$Just(s)
				});
		}));
var $author$project$DialogGameEditor$lens_startDialogId = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.startDialogId;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{startDialogId: s});
		}));
var $author$project$DialogGameEditor$model_startDialogId = A2($arturopala$elm_monocle$Monocle$Compose$lensWithLens, $author$project$DialogGameEditor$lens_startDialogId, $author$project$DialogGameEditor$model_gameDefinition);
var $author$project$DialogGameEditor$lens_title = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.title;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{title: s});
		}));
var $author$project$DialogGameEditor$model_title = A2($arturopala$elm_monocle$Monocle$Compose$lensWithLens, $author$project$DialogGameEditor$lens_title, $author$project$DialogGameEditor$model_gameDefinition);
var $arturopala$elm_monocle$Monocle$Lens$modify = F2(
	function (lens, f) {
		var mf = function (a) {
			return function (b) {
				return A2(lens.set, b, a);
			}(
				f(
					lens.get(a)));
		};
		return mf;
	});
var $arturopala$elm_monocle$Monocle$Optional$flip = F3(
	function (f, b, a) {
		return A2(f, a, b);
	});
var $arturopala$elm_monocle$Monocle$Optional$modifyOption = F2(
	function (opt, fx) {
		var mf = function (a) {
			return A2(
				$elm$core$Maybe$map,
				A2(
					$elm$core$Basics$composeR,
					fx,
					A2($arturopala$elm_monocle$Monocle$Optional$flip, opt.set, a)),
				opt.getOption(a));
		};
		return mf;
	});
var $arturopala$elm_monocle$Monocle$Optional$modify = F2(
	function (opt, fx) {
		var mf = function (a) {
			return A2(
				$elm$core$Maybe$withDefault,
				a,
				A3($arturopala$elm_monocle$Monocle$Optional$modifyOption, opt, fx, a));
		};
		return mf;
	});
var $author$project$DialogGameEditor$newDialog = {
	id: '',
	options: _List_Nil,
	text: $author$project$ScreeptV2$Literal(
		$author$project$ScreeptV2$Text(''))
};
var $arturopala$elm_monocle$Monocle$Compose$optionalWithLens = F2(
	function (inner, outer) {
		var set = function (c) {
			return A2(
				$arturopala$elm_monocle$Monocle$Optional$modify,
				outer,
				inner.set(c));
		};
		var getOption = A2(
			$elm$core$Basics$composeR,
			outer.getOption,
			$elm$core$Maybe$map(inner.get));
		return A2($arturopala$elm_monocle$Monocle$Optional$Optional, getOption, set);
	});
var $author$project$Shared$optional_editedProcedure = A2(
	$arturopala$elm_monocle$Monocle$Optional$Optional,
	function ($) {
		return $.editedProcedure;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					editedProcedure: $elm$core$Maybe$Just(s)
				});
		}));
var $author$project$Shared$parsedEditableStatement = function (value) {
	return A3($author$project$ParsedEditable$init, value, $author$project$ScreeptV2$parserStatement, $author$project$ScreeptV2$stringifyStatement);
};
var $author$project$Shared$parsedEditableExpression = function (value) {
	return A3($author$project$ParsedEditable$init, value, $author$project$ScreeptV2$parserExpression, $author$project$ScreeptV2$stringifyExpression);
};
var $author$project$DialogGameEditor$dialogToEditedDialog = function (dialog) {
	return {
		editedOption: $elm$core$Maybe$Nothing,
		id: dialog.id,
		oldValue: dialog,
		options: dialog.options,
		text: $author$project$Shared$parsedEditableExpression(dialog.text)
	};
};
var $author$project$Shared$startEditing = F4(
	function (model, optional_editedValue, value, fnValueToEditedValue) {
		return _Utils_eq(
			A2($arturopala$elm_monocle$Monocle$Compose$optionalWithLens, $author$project$Shared$lens_oldValue, optional_editedValue).getOption(model),
			$elm$core$Maybe$Just(value)) ? model : A2(
			optional_editedValue.set,
			fnValueToEditedValue(value),
			model);
	});
var $author$project$DialogGameEditor$startEditingDialog = F2(
	function (dialog, model) {
		return A4($author$project$Shared$startEditing, model, $author$project$DialogGameEditor$model_editedDialog, dialog, $author$project$DialogGameEditor$dialogToEditedDialog);
	});
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$DialogGameEditor$editedDialogOptionToDialogOption = function (editableOption) {
	var _v0 = $author$project$ParsedEditable$model_new.getOption(editableOption.text);
	if (_v0.$ === 'Just') {
		var text = _v0.a;
		return {
			actions: editableOption.actions,
			condition: A2($elm$core$Maybe$andThen, $author$project$ParsedEditable$model_new.getOption, editableOption.condition),
			text: text
		};
	} else {
		return editableOption.oldValue;
	}
};
var $author$project$DialogGameEditor$editedDialog_editedOption = A2(
	$arturopala$elm_monocle$Monocle$Optional$Optional,
	function ($) {
		return $.editedOption;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					editedOption: $elm$core$Maybe$Just(s)
				});
		}));
var $author$project$DialogGameEditor$lens_editedOption = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.editedOption;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{editedOption: s});
		}));
var $author$project$DialogGameEditor$lens_id = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.id;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{id: s});
		}));
var $author$project$DialogGameEditor$lens_options = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.options;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{options: s});
		}));
var $author$project$DialogGameEditor$lens_text = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.text;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{text: s});
		}));
var $author$project$DialogGameEditor$newOption = {
	actions: _List_Nil,
	condition: $elm$core$Maybe$Nothing,
	text: $author$project$ScreeptV2$Literal(
		$author$project$ScreeptV2$Text(''))
};
var $author$project$DialogGameEditor$dialogOptionToEditedOption = function (dialogOption) {
	return {
		actions: dialogOption.actions,
		condition: A2($elm$core$Maybe$map, $author$project$Shared$parsedEditableExpression, dialogOption.condition),
		editedAction: $elm$core$Maybe$Nothing,
		oldValue: dialogOption,
		text: $author$project$Shared$parsedEditableExpression(dialogOption.text)
	};
};
var $author$project$DialogGameEditor$startEditingOption = F2(
	function (dialogOption, dialog) {
		return A4($author$project$Shared$startEditing, dialog, $author$project$DialogGameEditor$editedDialog_editedOption, dialogOption, $author$project$DialogGameEditor$dialogOptionToEditedOption);
	});
var $author$project$ParsedEditable$revert = function (model) {
	return _Utils_update(
		model,
		{
			_new: $elm$core$Result$Ok(model.old),
			text: model.formatter(model.old)
		});
};
var $author$project$ParsedEditable$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'FormatClick':
				var parsed = A2($elm$parser$Parser$run, model.parser, model.text);
				var text = function () {
					if (parsed.$ === 'Ok') {
						var t = parsed.a;
						return model.formatter(t);
					} else {
						return model.text;
					}
				}();
				return _Utils_update(
					model,
					{_new: parsed, text: text});
			case 'TextEdit':
				var v = msg.a;
				return _Utils_update(
					model,
					{
						_new: A2($elm$parser$Parser$run, model.parser, v),
						text: v
					});
			default:
				return $author$project$ParsedEditable$revert(model);
		}
	});
var $author$project$DialogGameEditor$EAGo = function (a) {
	return {$: 'EAGo', a: a};
};
var $author$project$DialogGameEditor$EAGoBack = {$: 'EAGoBack'};
var $author$project$DialogGameEditor$EAScreept = function (a) {
	return {$: 'EAScreept', a: a};
};
var $author$project$DialogGameEditor$dialogActionToEditedAction = function (dialogAction) {
	switch (dialogAction.$) {
		case 'GoAction':
			var dialogId = dialogAction.a;
			return $author$project$DialogGameEditor$EAGo(dialogId);
		case 'GoBackAction':
			return $author$project$DialogGameEditor$EAGoBack;
		case 'Message':
			var expression = dialogAction.a;
			return $author$project$DialogGameEditor$EAGoBack;
		case 'Screept':
			var statement = dialogAction.a;
			return $author$project$DialogGameEditor$EAScreept(
				A3($author$project$ParsedEditable$init, statement, $author$project$ScreeptV2$parserStatement, $author$project$ScreeptV2$stringifyStatement));
		case 'ConditionalAction':
			var expression = dialogAction.a;
			var succes = dialogAction.b;
			var failure = dialogAction.c;
			return $author$project$DialogGameEditor$EAGoBack;
		case 'ActionBlock':
			var dialogActions = dialogAction.a;
			return $author$project$DialogGameEditor$EAGoBack;
		default:
			var string = dialogAction.a;
			return $author$project$DialogGameEditor$EAGoBack;
	}
};
var $author$project$DialogGameEditor$editedActionToDialogAction = function (action) {
	var _v0 = action.editedActionUI;
	switch (_v0.$) {
		case 'EAGoBack':
			return $author$project$DialogGame$GoBackAction;
		case 'EAGo':
			var string = _v0.a;
			return $author$project$DialogGame$GoAction(string);
		default:
			var statement = _v0.a;
			var _v1 = $author$project$ParsedEditable$model_new.getOption(statement);
			if (_v1.$ === 'Just') {
				var stmt = _v1.a;
				return $author$project$DialogGame$Screept(stmt);
			} else {
				return action.oldValue;
			}
	}
};
var $author$project$DialogGameEditor$editedOption_condition = A2(
	$arturopala$elm_monocle$Monocle$Optional$Optional,
	function ($) {
		return $.condition;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					condition: $elm$core$Maybe$Just(s)
				});
		}));
var $author$project$DialogGameEditor$editedOption_editedAction = A2(
	$arturopala$elm_monocle$Monocle$Optional$Optional,
	function ($) {
		return $.editedAction;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{
					editedAction: $elm$core$Maybe$Just(s)
				});
		}));
var $author$project$DialogGameEditor$editedOption_mCondition = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.condition;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{condition: s});
		}));
var $author$project$DialogGameEditor$editedOption_mEditedAction = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.editedAction;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{editedAction: s});
		}));
var $author$project$DialogGameEditor$lens_actions = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.actions;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{actions: s});
		}));
var $author$project$DialogGameEditor$newAction = $author$project$DialogGame$GoBackAction;
var $author$project$DialogGameEditor$editedAction_goTo = {
	getOption: function (ea) {
		if (ea.$ === 'EAGo') {
			var s = ea.a;
			return $elm$core$Maybe$Just(s);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	},
	reverseGet: $author$project$DialogGameEditor$EAGo
};
var $author$project$DialogGameEditor$editedAction_screept = {
	getOption: function (ea) {
		if (ea.$ === 'EAScreept') {
			var s = ea.a;
			return $elm$core$Maybe$Just(s);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	},
	reverseGet: $author$project$DialogGameEditor$EAScreept
};
var $author$project$DialogGameEditor$initEditedAction = function (kind) {
	switch (kind.$) {
		case 'ATGoBack':
			return $author$project$DialogGameEditor$EAGoBack;
		case 'ATGo':
			return $author$project$DialogGameEditor$EAGo('');
		default:
			return $author$project$DialogGameEditor$EAScreept(
				A3(
					$author$project$ParsedEditable$init,
					$author$project$ScreeptV2$Block(_List_Nil),
					$author$project$ScreeptV2$parserStatement,
					$author$project$ScreeptV2$stringifyStatement));
	}
};
var $arturopala$elm_monocle$Monocle$Prism$modifyOption = F2(
	function (prism, f) {
		return A2(
			$elm$core$Basics$composeR,
			prism.getOption,
			$elm$core$Maybe$map(
				A2($elm$core$Basics$composeR, f, prism.reverseGet)));
	});
var $arturopala$elm_monocle$Monocle$Prism$modify = F2(
	function (prism, f) {
		var m = function (x) {
			return A2(
				$elm$core$Maybe$withDefault,
				x,
				A3($arturopala$elm_monocle$Monocle$Prism$modifyOption, prism, f, x));
		};
		return m;
	});
var $author$project$DialogGameEditor$updateEditedAction = F2(
	function (actionEditAction, editedAction) {
		switch (actionEditAction.$) {
			case 'SelectActionType':
				var kind = actionEditAction.a;
				return _Utils_update(
					editedAction,
					{
						editedActionUI: $author$project$DialogGameEditor$initEditedAction(kind)
					});
			case 'EditGoToText':
				var string = actionEditAction.a;
				return _Utils_update(
					editedAction,
					{
						editedActionUI: $author$project$DialogGameEditor$editedAction_goTo.reverseGet(string)
					});
			default:
				var msg = actionEditAction.a;
				return _Utils_update(
					editedAction,
					{
						editedActionUI: A3(
							$arturopala$elm_monocle$Monocle$Prism$modify,
							$author$project$DialogGameEditor$editedAction_screept,
							$author$project$ParsedEditable$update(msg),
							editedAction.editedActionUI)
					});
		}
	});
var $elm_community$list_extra$List$Extra$updateIf = F3(
	function (predicate, update, list) {
		return A2(
			$elm$core$List$map,
			function (item) {
				return predicate(item) ? update(item) : item;
			},
			list);
	});
var $elm_community$list_extra$List$Extra$setIf = F3(
	function (predicate, replacement, list) {
		return A3(
			$elm_community$list_extra$List$Extra$updateIf,
			predicate,
			$elm$core$Basics$always(replacement),
			list);
	});
var $author$project$Shared$updateOldValueWithTransformation = F3(
	function (fn, list, _new) {
		return A3(
			$elm_community$list_extra$List$Extra$setIf,
			function (x) {
				return _Utils_eq(x, _new.oldValue);
			},
			fn(_new),
			list);
	});
var $author$project$DialogGameEditor$updateEditedOption = F2(
	function (optionEditAction, editedOption) {
		switch (optionEditAction.$) {
			case 'OptionTextEdit':
				var msg = optionEditAction.a;
				var _v1 = A2(
					$elm$core$Debug$log,
					'OTE',
					_Utils_Tuple3(msg, optionEditAction, editedOption));
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					$author$project$DialogGameEditor$lens_text,
					$author$project$ParsedEditable$update(msg),
					editedOption);
			case 'OptionConditionEdit':
				var msg = optionEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$editedOption_condition,
					$author$project$ParsedEditable$update(msg),
					editedOption);
			case 'OptionConditionRemove':
				return A2($author$project$DialogGameEditor$editedOption_mCondition.set, $elm$core$Maybe$Nothing, editedOption);
			case 'OptionConditionAdd':
				return A2(
					$author$project$DialogGameEditor$editedOption_condition.set,
					A3(
						$author$project$ParsedEditable$init,
						$author$project$ScreeptV2$Literal(
							$author$project$ScreeptV2$Number(1)),
						$author$project$ScreeptV2$parserExpression,
						$author$project$ScreeptV2$stringifyExpression),
					editedOption);
			case 'OptionActionStartEdit':
				var dialogAction = optionEditAction.a;
				return A4(
					$author$project$Shared$startEditing,
					editedOption,
					$author$project$DialogGameEditor$editedOption_editedAction,
					dialogAction,
					function (v) {
						return {
							editedActionUI: $author$project$DialogGameEditor$dialogActionToEditedAction(v),
							oldValue: v
						};
					});
			case 'OptionActionEditAction':
				var actionEditAction = optionEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$editedOption_editedAction,
					$author$project$DialogGameEditor$updateEditedAction(actionEditAction),
					editedOption);
			case 'SaveAction':
				var newActions = A2(
					$elm$core$Maybe$map,
					A2($author$project$Shared$updateOldValueWithTransformation, $author$project$DialogGameEditor$editedActionToDialogAction, editedOption.actions),
					$author$project$DialogGameEditor$editedOption_editedAction.getOption(editedOption));
				if (newActions.$ === 'Nothing') {
					return editedOption;
				} else {
					var neo = newActions.a;
					return A2(
						$author$project$DialogGameEditor$editedOption_mEditedAction.set,
						$elm$core$Maybe$Nothing,
						_Utils_update(
							editedOption,
							{actions: neo}));
				}
			case 'ActionEdit':
				var actionEditAction = optionEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$editedOption_editedAction,
					$author$project$DialogGameEditor$updateEditedAction(actionEditAction),
					editedOption);
			default:
				var manipulatePositionAction = optionEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					$author$project$DialogGameEditor$lens_actions,
					A2($author$project$Shared$manipulatePositionUpdate, $author$project$DialogGameEditor$newAction, manipulatePositionAction),
					editedOption);
		}
	});
var $author$project$DialogGameEditor$updateEditedDialog = F2(
	function (dialogEditAction, dialog) {
		switch (dialogEditAction.$) {
			case 'DialogTextEdit':
				var msg = dialogEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					$author$project$DialogGameEditor$lens_text,
					function (m) {
						return A2($author$project$ParsedEditable$update, msg, m);
					},
					dialog);
			case 'DialogIdEdit':
				var string = dialogEditAction.a;
				return A2($author$project$DialogGameEditor$lens_id.set, string, dialog);
			case 'StartOptionEdit':
				var dialogOption = dialogEditAction.a;
				return A2($author$project$DialogGameEditor$startEditingOption, dialogOption, dialog);
			case 'OptionEdit':
				var optionEditAction = dialogEditAction.a;
				var d = function () {
					if (optionEditAction.$ === 'OptionActionStartEdit') {
						var dialogAction = optionEditAction.a;
						return A2(
							$elm$core$Maybe$withDefault,
							dialog,
							A2(
								$elm$core$Maybe$map,
								function (x) {
									return A2($author$project$DialogGameEditor$startEditingOption, x, dialog);
								},
								A2(
									$elm_community$list_extra$List$Extra$find,
									function (o) {
										return A2($elm$core$List$member, dialogAction, o.actions);
									},
									dialog.options)));
					} else {
						return dialog;
					}
				}();
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$editedDialog_editedOption,
					$author$project$DialogGameEditor$updateEditedOption(optionEditAction),
					d);
			case 'OptionsManipulation':
				var manipulatePosition = dialogEditAction.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					$author$project$DialogGameEditor$lens_options,
					A2($author$project$Shared$manipulatePositionUpdate, $author$project$DialogGameEditor$newOption, manipulatePosition),
					dialog);
			default:
				var newOptions = A2(
					$elm$core$Maybe$map,
					A2($author$project$Shared$updateOldValueWithTransformation, $author$project$DialogGameEditor$editedDialogOptionToDialogOption, dialog.options),
					$author$project$DialogGameEditor$editedDialog_editedOption.getOption(dialog));
				if (newOptions.$ === 'Nothing') {
					return dialog;
				} else {
					var nd = newOptions.a;
					return A2(
						$author$project$DialogGameEditor$lens_editedOption.set,
						$elm$core$Maybe$Nothing,
						A2($author$project$DialogGameEditor$lens_options.set, nd, dialog));
				}
		}
	});
var $author$project$Shared$lens_definition = A2(
	$arturopala$elm_monocle$Monocle$Lens$Lens,
	function ($) {
		return $.definition;
	},
	F2(
		function (s, m) {
			return _Utils_update(
				m,
				{definition: s});
		}));
var $author$project$DialogGameEditor$updateEditedProcedure = F2(
	function (procedureEditAction, editedValue) {
		if (procedureEditAction.$ === 'EditProcName') {
			var string = procedureEditAction.a;
			return _Utils_update(
				editedValue,
				{name: string});
		} else {
			var msg = procedureEditAction.a;
			return A3(
				$arturopala$elm_monocle$Monocle$Lens$modify,
				$author$project$Shared$lens_definition,
				$author$project$ParsedEditable$update(msg),
				editedValue);
		}
	});
var $author$project$DialogGameEditor$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'StartDialogEdit':
				var dialog = msg.a;
				return A2($author$project$DialogGameEditor$startEditingDialog, dialog, model);
			case 'Save':
				var newDialogs = A2(
					$elm$core$Maybe$map,
					A2($author$project$Shared$updateOldValueWithTransformation, $author$project$DialogGameEditor$editedDialogToDialog, model.gameDefinition.dialogs),
					$author$project$DialogGameEditor$model_editedDialog.getOption(model));
				if (newDialogs.$ === 'Nothing') {
					return model;
				} else {
					var nd = newDialogs.a;
					return function (m) {
						return _Utils_update(
							m,
							{editedDialog: $elm$core$Maybe$Nothing});
					}(
						A2($author$project$DialogGameEditor$model_dialogs.set, nd, model));
				}
			case 'Cancel':
				return model;
			case 'DialogsManipulation':
				var manipulatePosition = msg.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					$author$project$DialogGameEditor$model_dialogs,
					A2($author$project$Shared$manipulatePositionUpdate, $author$project$DialogGameEditor$newDialog, manipulatePosition),
					model);
			case 'DialogEdit':
				var dialogAction = msg.a;
				var m = function () {
					if (dialogAction.$ === 'StartOptionEdit') {
						var dialogOption = dialogAction.a;
						return A2(
							$elm$core$Maybe$withDefault,
							model,
							A2(
								$elm$core$Maybe$map,
								function (x) {
									return A2($author$project$DialogGameEditor$startEditingDialog, x, model);
								},
								A2(
									$elm_community$list_extra$List$Extra$find,
									function (d) {
										return A2($elm$core$List$member, dialogOption, d.options);
									},
									model.gameDefinition.dialogs)));
					} else {
						return model;
					}
				}();
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$model_editedDialog,
					$author$project$DialogGameEditor$updateEditedDialog(dialogAction),
					m);
			case 'EditTitle':
				var string = msg.a;
				return A2($author$project$DialogGameEditor$model_title.set, string, model);
			case 'EditStartDialogId':
				var string = msg.a;
				return A2($author$project$DialogGameEditor$model_startDialogId.set, string, model);
			case 'ProcedureManipulation':
				var manipulatePositionAction = msg.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Lens$modify,
					A2($arturopala$elm_monocle$Monocle$Compose$lensWithLens, $author$project$DialogGameEditor$lens_procedures, $author$project$DialogGameEditor$model_gameDefinition),
					A2(
						$author$project$Shared$manipulatePositionUpdate,
						_Utils_Tuple2(
							'procName    ',
							$author$project$ScreeptV2$Block(_List_Nil)),
						manipulatePositionAction),
					model);
			case 'StartProcedureEdit':
				var _v3 = msg.a;
				var name = _v3.a;
				var statement = _v3.b;
				return _Utils_eq(
					A2($arturopala$elm_monocle$Monocle$Compose$optionalWithLens, $author$project$Shared$lens_oldValue, $author$project$Shared$optional_editedProcedure).getOption(model),
					$elm$core$Maybe$Just(
						_Utils_Tuple2(name, statement))) ? model : A2(
					$author$project$Shared$lens_editedProcedure.set,
					$elm$core$Maybe$Just(
						{
							definition: $author$project$Shared$parsedEditableStatement(statement),
							name: name,
							oldValue: _Utils_Tuple2(name, statement)
						}),
					model);
			case 'ProcedureEdit':
				var procedureEditAction = msg.a;
				return A3(
					$arturopala$elm_monocle$Monocle$Optional$modify,
					$author$project$DialogGameEditor$model_editedProcedure,
					$author$project$DialogGameEditor$updateEditedProcedure(procedureEditAction),
					model);
			default:
				var newProcedures = A2(
					$elm$core$Maybe$map,
					A2($author$project$Shared$updateOldValueWithTransformation, $author$project$DialogGameEditor$editedProcedureToProcedure, model.gameDefinition.procedures),
					$author$project$DialogGameEditor$model_editedProcedure.getOption(model));
				if (newProcedures.$ === 'Nothing') {
					return model;
				} else {
					var nd = newProcedures.a;
					return function (m) {
						return _Utils_update(
							m,
							{editedProcedure: $elm$core$Maybe$Nothing});
					}(
						A2(
							A2($arturopala$elm_monocle$Monocle$Compose$lensWithLens, $author$project$DialogGameEditor$lens_procedures, $author$project$DialogGameEditor$model_gameDefinition).set,
							nd,
							model));
				}
		}
	});
var $author$project$ScreeptEditor$update = F2(
	function (msg, model) {
		var m = msg.a;
		return _Utils_update(
			model,
			{
				statementEditor: A2($author$project$ParsedEditable$update, m, model.statementEditor)
			});
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'None':
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 'GameDialog':
				var gdm = msg.a;
				var _v1 = model.gameDialog;
				if (_v1.$ === 'Started') {
					var gamedef = _v1.a;
					var gameDialogModel = _v1.b;
					var _v2 = A2($author$project$DialogGame$update, gdm, gameDialogModel);
					var gdModel = _v2.a;
					var exitCode = _v2.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								gameDialog: A2($author$project$Main$Started, gamedef, gdModel)
							}),
						$elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'SeedGenerated':
				var seed = msg.a;
				var _v3 = model.gameDialog;
				if (_v3.$ === 'Started') {
					var gamedef = _v3.a;
					var gameDialogModel = _v3.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								gameDialog: A2(
									$author$project$Main$Started,
									gamedef,
									A2($author$project$DialogGame$setRndSeed, seed, gameDialogModel))
							}),
						$elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'ScreeptEditor':
				var seMsg = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							screeptEditor: A2($author$project$ScreeptEditor$update, seMsg, model.screeptEditor)
						}),
					$elm$core$Platform$Cmd$none);
			case 'DialogEditor':
				var deMsg = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							dialogEditor: A2(
								$elm$core$Maybe$map,
								$author$project$DialogGameEditor$update(deMsg),
								model.dialogEditor)
						}),
					$elm$core$Platform$Cmd$none);
			case 'GotGameDefinition':
				var result = msg.a;
				if (result.$ === 'Err') {
					var e = result.a;
					var _v5 = A2($elm$core$Debug$log, 'Error', e);
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				} else {
					var value = result.a;
					var m = model.mainMenuDialog;
					var gameState = m.gameState;
					var _v6 = A2($author$project$ScreeptV2$executeStringStatement, '{ game_loaded = 1;  game_title = \"' + (value.title + '\" }'), m.gameState.screeptEnv);
					var newScreeptState = _v6.a;
					var newGameState = _Utils_update(
						gameState,
						{screeptEnv: newScreeptState});
					var menuDialog = _Utils_update(
						m,
						{gameState: newGameState});
					var _v7 = A2($elm$core$Debug$log, 'Success decode', value.dialogs);
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								dialogEditor: $elm$core$Maybe$Just(
									$author$project$DialogGameEditor$init(value)),
								gameDialog: $author$project$Main$Loaded(value),
								mainMenuDialog: menuDialog
							}),
						$elm$core$Platform$Cmd$none);
				}
			case 'MainMenuDialog':
				var menuMsg = msg.a;
				var _v8 = A2($author$project$DialogGame$update, menuMsg, model.mainMenuDialog);
				var menuModel = _v8.a;
				var exitCode = _v8.b;
				var _v9 = A2($author$project$Main$mainMenuActions, menuModel, exitCode);
				var newMenuModel = _v9.a;
				var cmd = _v9.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{mainMenuDialog: newMenuModel}),
					cmd);
			case 'StartGame':
				var gameDialog = function (gameDefinition) {
					var m = $author$project$Main$initGameFromGameDefinition(gameDefinition);
					return A2($author$project$Main$Started, gameDefinition, m);
				};
				var _v10 = model.gameDialog;
				switch (_v10.$) {
					case 'NotLoaded':
						return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
					case 'Loading':
						return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
					case 'Loaded':
						var gameDefinition = _v10.a;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									gameDialog: gameDialog(gameDefinition)
								}),
							A2($elm$random$Random$generate, $author$project$Main$SeedGenerated, $elm$random$Random$independentSeed));
					default:
						var gameDefinition = _v10.a;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									gameDialog: gameDialog(gameDefinition)
								}),
							A2($elm$random$Random$generate, $author$project$Main$SeedGenerated, $elm$random$Random$independentSeed));
				}
			case 'StopGame':
				var _v11 = model.gameDialog;
				if (_v11.$ === 'Started') {
					var gd = _v11.a;
					var m = _v11.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								gameDialog: $author$project$Main$Loaded(gd)
							}),
						$elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'ShowUrlLoader':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							urlLoader: $elm$core$Maybe$Just('')
						}),
					$elm$core$Platform$Cmd$none);
			case 'HideUrlLoader':
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{urlLoader: $elm$core$Maybe$Nothing}),
					$elm$core$Platform$Cmd$none);
			case 'EditUrlLoader':
				var v = msg.a;
				var urlModel = A2(
					$elm$core$Maybe$map,
					$elm$core$Basics$always(v),
					model.urlLoader);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{urlLoader: urlModel}),
					$elm$core$Platform$Cmd$none);
			case 'ClickUrlLoader':
				var _v12 = model.urlLoader;
				if (_v12.$ === 'Just') {
					var urlLoader = _v12.a;
					var _v13 = A2($elm$core$Debug$log, 'URL', urlLoader);
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{urlLoader: $elm$core$Maybe$Nothing}),
						$elm$http$Http$get(
							{
								expect: A2($elm$http$Http$expectJson, $author$project$Main$GotGameDefinition, $author$project$DialogGame$decodeGameDefinition),
								url: urlLoader
							}));
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			default:
				var _v14 = A2(
					$elm$core$Debug$log,
					'SGD',
					A2(
						$elm$core$Maybe$map,
						A2(
							$elm$core$Basics$composeR,
							function ($) {
								return $.gameDefinition;
							},
							$author$project$DialogGame$stringifyGameDefinition),
						model.dialogEditor));
				return _Utils_Tuple2(
					model,
					A2(
						$elm$core$Maybe$withDefault,
						$elm$core$Platform$Cmd$none,
						A2(
							$elm$core$Maybe$map,
							A2(
								$elm$core$Basics$composeR,
								function ($) {
									return $.gameDefinition;
								},
								A2($elm$core$Basics$composeR, $author$project$DialogGame$stringifyGameDefinition, $author$project$Main$saveGame)),
							model.dialogEditor)));
		}
	});
var $author$project$Main$DialogEditor = function (a) {
	return {$: 'DialogEditor', a: a};
};
var $author$project$Main$GameDialog = function (a) {
	return {$: 'GameDialog', a: a};
};
var $author$project$Main$MainMenuDialog = function (a) {
	return {$: 'MainMenuDialog', a: a};
};
var $author$project$Main$SaveGameDefinition = {$: 'SaveGameDefinition'};
var $author$project$Main$ScreeptEditor = function (a) {
	return {$: 'ScreeptEditor', a: a};
};
var $elm$html$Html$button = _VirtualDom_node('button');
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var $elm$html$Html$map = $elm$virtual_dom$VirtualDom$map;
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $author$project$DialogGame$badDialog = {
	id: 'bad',
	options: _List_Nil,
	text: $author$project$ScreeptV2$Literal(
		$author$project$ScreeptV2$Text('BAD Dialog'))
};
var $author$project$DialogGame$getDialog = F2(
	function (dialogId, dialogs) {
		return A2(
			$elm$core$Maybe$withDefault,
			$author$project$DialogGame$badDialog,
			A2($elm$core$Dict$get, dialogId, dialogs));
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $mhoare$elm_stack$Stack$top = function (_v0) {
	var stack = _v0.a;
	return $elm$core$List$head(stack);
};
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $author$project$DialogGame$viewDebug = function (gameState) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('status')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text('Debug'),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'display', 'grid'),
						A2($elm$html$Html$Attributes$style, 'grid-template-columns', 'repeat(4,1fr)')
					]),
				A2(
					$elm$core$List$map,
					function (_v0) {
						var k = _v0.a;
						var v = _v0.b;
						return A2(
							$elm$html$Html$div,
							_List_Nil,
							_List_fromArray(
								[
									$elm$html$Html$text(
									k + (':' + $author$project$ScreeptV2$stringifyValue(v)))
								]));
					},
					$elm$core$Dict$toList(gameState.screeptEnv.vars)))
			]));
};
var $author$project$ScreeptV2$evaluateExpressionToString = F2(
	function (env, expr) {
		return A2(
			$elm$core$Result$withDefault,
			'',
			A2(
				$elm$core$Result$map,
				$author$project$ScreeptV2$getStringFromValue,
				A2($author$project$ScreeptV2$evaluateExpression, env, expr)));
	});
var $elm$html$Html$p = _VirtualDom_node('p');
var $author$project$DialogGame$viewDialogText = F2(
	function (expr, gameState) {
		var s = A2($author$project$ScreeptV2$evaluateExpressionToString, gameState.screeptEnv, expr);
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			A2(
				$elm$core$List$map,
				function (par) {
					return A2(
						$elm$html$Html$p,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text(par)
							]));
				},
				A2($elm$core$String$split, '\n', s)));
	});
var $author$project$DialogGame$viewMessages = function (msgs) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('messages')
			]),
		A2(
			$elm$core$List$map,
			function (m) {
				return A2(
					$elm$html$Html$p,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class('message')
						]),
					_List_fromArray(
						[
							$elm$html$Html$text(m)
						]));
			},
			msgs));
};
var $author$project$DialogGame$ClickDialog = function (a) {
	return {$: 'ClickDialog', a: a};
};
var $author$project$DialogGame$viewOption = F2(
	function (gameState, dialogOption) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Events$onClick(
					$author$project$DialogGame$ClickDialog(dialogOption.actions)),
					$elm$html$Html$Attributes$class('option')
				]),
			_List_fromArray(
				[
					$elm$html$Html$text(
					A2($author$project$ScreeptV2$evaluateExpressionToString, gameState.screeptEnv, dialogOption.text))
				]));
	});
var $author$project$DialogGame$view = function (_v0) {
	var gameState = _v0.gameState;
	var dialogs = _v0.dialogs;
	var dialog = A2(
		$author$project$DialogGame$getDialog,
		A2(
			$elm$core$Maybe$withDefault,
			'bad',
			$mhoare$elm_stack$Stack$top(gameState.dialogStack)),
		dialogs);
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('container')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('dialog')
					]),
				_List_fromArray(
					[
						A2($elm$core$Dict$member, '__statusLine', gameState.screeptEnv.vars) ? A2(
						$author$project$DialogGame$viewDialogText,
						A2(
							$author$project$ScreeptV2$FunctionCall,
							$author$project$ScreeptV2$LiteralIdentifier('__statusLine'),
							_List_Nil),
						gameState) : $elm$html$Html$text(''),
						A2($author$project$DialogGame$viewDialogText, dialog.text, gameState),
						function () {
						var isVisible = function (mCondition) {
							return A2(
								$elm$core$Maybe$withDefault,
								true,
								A2(
									$elm$core$Maybe$map,
									function (condition) {
										return A2(
											$elm$core$Result$withDefault,
											false,
											A2(
												$elm$core$Result$map,
												$author$project$ScreeptV2$isTruthy,
												A2($author$project$ScreeptV2$evaluateExpression, gameState.screeptEnv, condition)));
									},
									mCondition));
						};
						return A2(
							$elm$html$Html$div,
							_List_Nil,
							A2(
								$elm$core$List$map,
								$author$project$DialogGame$viewOption(gameState),
								A2(
									$elm$core$List$filter,
									function (o) {
										return isVisible(o.condition);
									},
									dialog.options)));
					}()
					])),
				($elm$core$List$length(gameState.messages) > 0) ? $author$project$DialogGame$viewMessages(gameState.messages) : $elm$html$Html$text(''),
				$author$project$DialogGame$viewDebug(gameState)
			]));
};
var $author$project$DialogGameEditor$EditStartDialogId = function (a) {
	return {$: 'EditStartDialogId', a: a};
};
var $author$project$DialogGameEditor$EditTitle = function (a) {
	return {$: 'EditTitle', a: a};
};
var $author$project$DialogGameEditor$getDialogIds = function (model) {
	return A2(
		$elm$core$List$map,
		function ($) {
			return $.id;
		},
		model.gameDefinition.dialogs);
};
var $elm$html$Html$h5 = _VirtualDom_node('h5');
var $elm$html$Html$h6 = _VirtualDom_node('h6');
var $elm$html$Html$input = _VirtualDom_node('input');
var $elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var $elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 'MayStopPropagation', a: a};
};
var $elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$html$Html$Events$targetValue = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	$elm$json$Json$Decode$string);
var $elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		$elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			$elm$json$Json$Decode$map,
			$elm$html$Html$Events$alwaysStop,
			A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue)));
};
var $elm$html$Html$option = _VirtualDom_node('option');
var $elm$html$Html$select = _VirtualDom_node('select');
var $elm$json$Json$Encode$bool = _Json_wrap;
var $elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$bool(bool));
	});
var $elm$html$Html$Attributes$selected = $elm$html$Html$Attributes$boolProperty('selected');
var $elm$html$Html$textarea = _VirtualDom_node('textarea');
var $elm$html$Html$Attributes$value = $elm$html$Html$Attributes$stringProperty('value');
var $author$project$DialogGameEditor$DialogEdit = function (a) {
	return {$: 'DialogEdit', a: a};
};
var $author$project$DialogGameEditor$DialogIdEdit = function (a) {
	return {$: 'DialogIdEdit', a: a};
};
var $author$project$DialogGameEditor$DialogTextEdit = function (a) {
	return {$: 'DialogTextEdit', a: a};
};
var $author$project$DialogGameEditor$DialogsManipulation = function (a) {
	return {$: 'DialogsManipulation', a: a};
};
var $author$project$DialogGameEditor$Save = {$: 'Save'};
var $author$project$DialogGameEditor$StartDialogEdit = function (a) {
	return {$: 'StartDialogEdit', a: a};
};
var $author$project$DialogGameEditor$model_Dialog = A2($arturopala$elm_monocle$Monocle$Compose$optionalWithLens, $author$project$Shared$lens_oldValue, $author$project$DialogGameEditor$model_editedDialog);
var $elm$html$Html$span = _VirtualDom_node('span');
var $author$project$ParsedEditable$FormatClick = {$: 'FormatClick'};
var $author$project$ParsedEditable$Revert = {$: 'Revert'};
var $author$project$ParsedEditable$TextEdit = function (a) {
	return {$: 'TextEdit', a: a};
};
var $author$project$ParsedEditable$problemToString = function (problem) {
	switch (problem.$) {
		case 'Expecting':
			var string = problem.a;
			return 'Expecting ' + string;
		case 'ExpectingInt':
			return 'Expecting Int ';
		case 'ExpectingHex':
			return 'ExpectingHex';
		case 'ExpectingOctal':
			return 'ExpectingOctal';
		case 'ExpectingBinary':
			return 'ExpectingBinary';
		case 'ExpectingFloat':
			return 'ExpectingFloat';
		case 'ExpectingNumber':
			return 'ExpectingNumber';
		case 'ExpectingVariable':
			return 'ExpectingVariable';
		case 'ExpectingSymbol':
			var string = problem.a;
			return 'ExpectingSymbol ' + string;
		case 'ExpectingKeyword':
			var string = problem.a;
			return 'ExpectingKeyword ' + string;
		case 'ExpectingEnd':
			return 'ExpectingEnd';
		case 'UnexpectedChar':
			return 'UnexpectedChar';
		case 'Problem':
			var string = problem.a;
			return 'Problem ' + string;
		default:
			return 'BadRepeat';
	}
};
var $author$project$ParsedEditable$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$textarea,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$value(model.text),
						$elm$html$Html$Events$onInput($author$project$ParsedEditable$TextEdit),
						A2($elm$html$Html$Attributes$style, 'width', '100%'),
						A2($elm$html$Html$Attributes$style, 'height', '10em'),
						A2($elm$html$Html$Attributes$style, 'font-family', 'monospace')
					]),
				_List_Nil),
				A2(
				$elm$html$Html$button,
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick($author$project$ParsedEditable$FormatClick)
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Format')
					])),
				A2(
				$elm$html$Html$button,
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick($author$project$ParsedEditable$Revert)
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Revert')
					])),
				function () {
				var _v0 = model._new;
				if (_v0.$ === 'Ok') {
					return $elm$html$Html$text('Parsed ok');
				} else {
					var errors = _v0.a;
					var viewProblem = function (_v1) {
						var row = _v1.row;
						var col = _v1.col;
						var problem = _v1.problem;
						return A2(
							$elm$html$Html$div,
							_List_Nil,
							_List_fromArray(
								[
									$elm$html$Html$text(
									'row: ' + ($elm$core$String$fromInt(row) + (', col: ' + ($elm$core$String$fromInt(col) + (', problem: ' + $author$project$ParsedEditable$problemToString(problem))))))
								]));
					};
					return A2(
						$elm$html$Html$div,
						_List_Nil,
						A2($elm$core$List$map, viewProblem, errors));
				}
			}()
			]));
};
var $author$project$DialogGameEditor$elipsisText = function (s) {
	return ($elm$core$String$length(s) > 100) ? (A3($elm$core$String$slice, 0, 100, s) + '...') : s;
};
var $author$project$DialogGameEditor$viewExpression = function (expression) {
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('de-dialog-condition')
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(
				$author$project$DialogGameEditor$elipsisText(
					$author$project$ScreeptV2$stringifyExpression(expression)))
			]));
};
var $author$project$Shared$DeletePosition = function (a) {
	return {$: 'DeletePosition', a: a};
};
var $author$project$Shared$MovePosition = F2(
	function (a, b) {
		return {$: 'MovePosition', a: a, b: b};
	});
var $author$project$Shared$NewAt = function (a) {
	return {$: 'NewAt', a: a};
};
var $author$project$Shared$viewManipulateButtons = F3(
	function (kind, msgWrap, index) {
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							msgWrap(
								A2($author$project$Shared$MovePosition, index, -1)))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Move Up ' + kind)
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							msgWrap(
								A2($author$project$Shared$MovePosition, index, 1)))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Move Down ' + kind)
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							msgWrap(
								$author$project$Shared$DeletePosition(index)))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Delete ' + kind)
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							msgWrap(
								$author$project$Shared$NewAt(index + 1)))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('New ' + kind)
						]))
				]));
	});
var $author$project$DialogGameEditor$OptionConditionAdd = {$: 'OptionConditionAdd'};
var $author$project$DialogGameEditor$OptionConditionEdit = function (a) {
	return {$: 'OptionConditionEdit', a: a};
};
var $author$project$DialogGameEditor$OptionConditionRemove = {$: 'OptionConditionRemove'};
var $author$project$DialogGameEditor$OptionEdit = function (a) {
	return {$: 'OptionEdit', a: a};
};
var $author$project$DialogGameEditor$OptionTextEdit = function (a) {
	return {$: 'OptionTextEdit', a: a};
};
var $author$project$DialogGameEditor$OptionsManipulation = function (a) {
	return {$: 'OptionsManipulation', a: a};
};
var $author$project$DialogGameEditor$SaveOption = {$: 'SaveOption'};
var $author$project$DialogGameEditor$StartOptionEdit = function (a) {
	return {$: 'StartOptionEdit', a: a};
};
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $author$project$DialogGameEditor$ActionsManipulation = function (a) {
	return {$: 'ActionsManipulation', a: a};
};
var $author$project$DialogGameEditor$OptionActionStartEdit = function (a) {
	return {$: 'OptionActionStartEdit', a: a};
};
var $author$project$DialogGameEditor$viewAction = F3(
	function (isEdited, optionIndex, dialogAction) {
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					$elm$html$Html$text(
					function () {
						switch (dialogAction.$) {
							case 'Message':
								var expr = dialogAction.a;
								return 'Message: ' + $author$project$ScreeptV2$stringifyExpression(expr);
							case 'GoAction':
								var dialogId = dialogAction.a;
								return 'Go: ' + dialogId;
							case 'GoBackAction':
								return 'GoBack';
							case 'Screept':
								var statement = dialogAction.a;
								return 'Screept: ' + $author$project$ScreeptV2$stringifyStatement(statement);
							case 'ConditionalAction':
								var expression = dialogAction.a;
								var success = dialogAction.b;
								var failure = dialogAction.c;
								return 'IF';
							case 'ActionBlock':
								var dialogActions = dialogAction.a;
								return '[]';
							default:
								var string = dialogAction.a;
								return 'EXIT ' + string;
						}
					}()),
					isEdited ? A3(
					$author$project$Shared$viewManipulateButtons,
					'action',
					A2(
						$elm$core$Basics$composeL,
						A2($elm$core$Basics$composeL, $author$project$DialogGameEditor$DialogEdit, $author$project$DialogGameEditor$OptionEdit),
						$author$project$DialogGameEditor$ActionsManipulation),
					optionIndex) : $elm$html$Html$text(''),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							$author$project$DialogGameEditor$DialogEdit(
								$author$project$DialogGameEditor$OptionEdit(
									$author$project$DialogGameEditor$OptionActionStartEdit(dialogAction))))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Edit Action')
						]))
				]));
	});
var $author$project$DialogGameEditor$ATGo = {$: 'ATGo'};
var $author$project$DialogGameEditor$ATGoBack = {$: 'ATGoBack'};
var $author$project$DialogGameEditor$ATScreept = {$: 'ATScreept'};
var $author$project$DialogGameEditor$EditGoToText = function (a) {
	return {$: 'EditGoToText', a: a};
};
var $author$project$DialogGameEditor$EditScreept = function (a) {
	return {$: 'EditScreept', a: a};
};
var $author$project$DialogGameEditor$OptionActionEditAction = function (a) {
	return {$: 'OptionActionEditAction', a: a};
};
var $author$project$DialogGameEditor$SaveAction = {$: 'SaveAction'};
var $author$project$DialogGameEditor$SelectActionType = function (a) {
	return {$: 'SelectActionType', a: a};
};
var $author$project$DialogGameEditor$viewActionEdited = F3(
	function (editedAction, i, da) {
		return (!_Utils_eq(editedAction.oldValue, da)) ? A3($author$project$DialogGameEditor$viewAction, true, i, da) : A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					function () {
					var _v0 = editedAction.editedActionUI;
					if (_v0.$ === 'EAGoBack') {
						return $elm$html$Html$text('Go back');
					} else {
						return A2(
							$elm$html$Html$button,
							_List_fromArray(
								[
									$elm$html$Html$Events$onClick(
									$author$project$DialogGameEditor$DialogEdit(
										$author$project$DialogGameEditor$OptionEdit(
											$author$project$DialogGameEditor$OptionActionEditAction(
												$author$project$DialogGameEditor$SelectActionType($author$project$DialogGameEditor$ATGoBack)))))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Go Back')
								]));
					}
				}(),
					function () {
					var _v1 = editedAction.editedActionUI;
					if (_v1.$ === 'EAGo') {
						var goTo = _v1.a;
						return A2(
							$elm$html$Html$span,
							_List_Nil,
							_List_fromArray(
								[
									$elm$html$Html$text('GoTo'),
									A2(
									$elm$html$Html$input,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$value(goTo),
											$elm$html$Html$Events$onInput(
											A2(
												$elm$core$Basics$composeL,
												A2(
													$elm$core$Basics$composeL,
													A2($elm$core$Basics$composeL, $author$project$DialogGameEditor$DialogEdit, $author$project$DialogGameEditor$OptionEdit),
													$author$project$DialogGameEditor$OptionActionEditAction),
												$author$project$DialogGameEditor$EditGoToText))
										]),
									_List_Nil)
								]));
					} else {
						return A2(
							$elm$html$Html$button,
							_List_fromArray(
								[
									$elm$html$Html$Events$onClick(
									$author$project$DialogGameEditor$DialogEdit(
										$author$project$DialogGameEditor$OptionEdit(
											$author$project$DialogGameEditor$OptionActionEditAction(
												$author$project$DialogGameEditor$SelectActionType($author$project$DialogGameEditor$ATGo)))))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Go to ..')
								]));
					}
				}(),
					function () {
					var _v2 = editedAction.editedActionUI;
					if (_v2.$ === 'EAScreept') {
						var screept = _v2.a;
						return A2(
							$elm$html$Html$map,
							A2(
								$elm$core$Basics$composeR,
								$author$project$DialogGameEditor$EditScreept,
								A2(
									$elm$core$Basics$composeR,
									$author$project$DialogGameEditor$OptionActionEditAction,
									A2($elm$core$Basics$composeR, $author$project$DialogGameEditor$OptionEdit, $author$project$DialogGameEditor$DialogEdit))),
							$author$project$ParsedEditable$view(screept));
					} else {
						return A2(
							$elm$html$Html$button,
							_List_fromArray(
								[
									$elm$html$Html$Events$onClick(
									$author$project$DialogGameEditor$DialogEdit(
										$author$project$DialogGameEditor$OptionEdit(
											$author$project$DialogGameEditor$OptionActionEditAction(
												$author$project$DialogGameEditor$SelectActionType($author$project$DialogGameEditor$ATScreept)))))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Screept')
								]));
					}
				}(),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							$author$project$DialogGameEditor$DialogEdit(
								$author$project$DialogGameEditor$OptionEdit($author$project$DialogGameEditor$SaveAction)))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Save Action')
						]))
				]));
	});
var $author$project$DialogGameEditor$viewOption = F4(
	function (mEditedOption, isDialogEditing, optionIndex, dialogOption) {
		var isOptionEdited = A2(
			$elm$core$Maybe$withDefault,
			false,
			A2(
				$elm$core$Maybe$map,
				function (eop) {
					return _Utils_eq(eop.oldValue, dialogOption);
				},
				mEditedOption));
		var _v0 = _Utils_Tuple2(mEditedOption, isOptionEdited);
		if ((_v0.a.$ === 'Just') && _v0.b) {
			var editedOption = _v0.a.a;
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('de-dialog-option')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('text: '),
								A2(
								$elm$html$Html$map,
								A2(
									$elm$core$Basics$composeR,
									$author$project$DialogGameEditor$OptionTextEdit,
									A2($elm$core$Basics$composeR, $author$project$DialogGameEditor$OptionEdit, $author$project$DialogGameEditor$DialogEdit)),
								$author$project$ParsedEditable$view(editedOption.text))
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('condition: '),
								function () {
								var _v1 = editedOption.condition;
								if (_v1.$ === 'Just') {
									var condition = _v1.a;
									return A2(
										$elm$html$Html$div,
										_List_Nil,
										_List_fromArray(
											[
												A2(
												$elm$html$Html$map,
												A2(
													$elm$core$Basics$composeR,
													$author$project$DialogGameEditor$OptionConditionEdit,
													A2($elm$core$Basics$composeR, $author$project$DialogGameEditor$OptionEdit, $author$project$DialogGameEditor$DialogEdit)),
												$author$project$ParsedEditable$view(condition)),
												A2(
												$elm$html$Html$button,
												_List_fromArray(
													[
														$elm$html$Html$Events$onClick(
														$author$project$DialogGameEditor$DialogEdit(
															$author$project$DialogGameEditor$OptionEdit($author$project$DialogGameEditor$OptionConditionRemove)))
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Remove condition')
													]))
											]));
								} else {
									return A2(
										$elm$html$Html$div,
										_List_Nil,
										_List_fromArray(
											[
												$elm$html$Html$text('n/a'),
												A2(
												$elm$html$Html$button,
												_List_fromArray(
													[
														$elm$html$Html$Events$onClick(
														$author$project$DialogGameEditor$DialogEdit(
															$author$project$DialogGameEditor$OptionEdit($author$project$DialogGameEditor$OptionConditionAdd)))
													]),
												_List_fromArray(
													[
														$elm$html$Html$text('Add condition')
													]))
											]));
								}
							}()
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('actions:'),
								A2(
								$elm$html$Html$div,
								_List_Nil,
								function () {
									var _v2 = editedOption.editedAction;
									if (_v2.$ === 'Nothing') {
										return A2(
											$elm$core$List$indexedMap,
											$author$project$DialogGameEditor$viewAction(true),
											editedOption.actions);
									} else {
										var ea = _v2.a;
										return A2(
											$elm$core$List$indexedMap,
											$author$project$DialogGameEditor$viewActionEdited(ea),
											editedOption.actions);
									}
								}())
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$elm$html$Html$button,
								_List_fromArray(
									[
										$elm$html$Html$Events$onClick(
										$author$project$DialogGameEditor$DialogEdit($author$project$DialogGameEditor$SaveOption))
									]),
								_List_fromArray(
									[
										$elm$html$Html$text('Save Option')
									]))
							]))
					]));
		} else {
			return A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('de-dialog-option')
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('op_text: '),
								$author$project$DialogGameEditor$viewExpression(dialogOption.text)
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('condition: '),
								A2(
								$elm$core$Maybe$withDefault,
								$elm$html$Html$text('n/a'),
								A2($elm$core$Maybe$map, $author$project$DialogGameEditor$viewExpression, dialogOption.condition))
							])),
						A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('actions:'),
								A2(
								$elm$html$Html$div,
								_List_Nil,
								A2(
									$elm$core$List$indexedMap,
									$author$project$DialogGameEditor$viewAction(false),
									dialogOption.actions))
							])),
						isDialogEditing ? A3(
						$author$project$Shared$viewManipulateButtons,
						'option',
						A2($elm$core$Basics$composeL, $author$project$DialogGameEditor$DialogEdit, $author$project$DialogGameEditor$OptionsManipulation),
						optionIndex) : $elm$html$Html$text(''),
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick(
								$author$project$DialogGameEditor$DialogEdit(
									$author$project$DialogGameEditor$StartOptionEdit(dialogOption)))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Edit Option')
							]))
					]));
		}
	});
var $author$project$DialogGameEditor$viewDialog = F3(
	function (model, i, dialog) {
		var isEdited = _Utils_eq(
			$author$project$DialogGameEditor$model_Dialog.getOption(model),
			$elm$core$Maybe$Just(dialog));
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class('de-dialog')
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text('id: '),
							function () {
							var _v0 = _Utils_Tuple2(model.editedDialog, isEdited);
							if ((_v0.a.$ === 'Just') && _v0.b) {
								var edModel = _v0.a.a;
								return A2(
									$elm$html$Html$input,
									_List_fromArray(
										[
											$elm$html$Html$Events$onInput(
											function (a) {
												return $author$project$DialogGameEditor$DialogEdit(
													$author$project$DialogGameEditor$DialogIdEdit(a));
											}),
											$elm$html$Html$Attributes$value(edModel.id)
										]),
									_List_Nil);
							} else {
								return A2(
									$elm$html$Html$span,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$class('de-dialog-id')
										]),
									_List_fromArray(
										[
											$elm$html$Html$text(dialog.id)
										]));
							}
						}()
						])),
					A2(
					$elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text('text: '),
							function () {
							var _v1 = _Utils_Tuple2(model.editedDialog, isEdited);
							if ((_v1.a.$ === 'Just') && _v1.b) {
								var edModel = _v1.a.a;
								return A2(
									$elm$html$Html$div,
									_List_Nil,
									_List_fromArray(
										[
											A2(
											$elm$html$Html$map,
											function (a) {
												return $author$project$DialogGameEditor$DialogEdit(
													$author$project$DialogGameEditor$DialogTextEdit(a));
											},
											$author$project$ParsedEditable$view(edModel.text))
										]));
							} else {
								return $author$project$DialogGameEditor$viewExpression(dialog.text);
							}
						}()
						])),
					A2(
					$elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							$elm$html$Html$text('options:'),
							function () {
							var _v2 = _Utils_Tuple2(model.editedDialog, isEdited);
							if ((_v2.a.$ === 'Just') && _v2.b) {
								var edModel = _v2.a.a;
								return A2(
									$elm$html$Html$div,
									_List_Nil,
									A2(
										$elm$core$List$indexedMap,
										A2($author$project$DialogGameEditor$viewOption, edModel.editedOption, true),
										edModel.options));
							} else {
								return A2(
									$elm$html$Html$div,
									_List_Nil,
									A2(
										$elm$core$List$indexedMap,
										A2($author$project$DialogGameEditor$viewOption, $elm$core$Maybe$Nothing, false),
										dialog.options));
							}
						}()
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick($author$project$DialogGameEditor$Save)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Save')
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick(
							$author$project$DialogGameEditor$StartDialogEdit(dialog))
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('EDIT')
						])),
					A3($author$project$Shared$viewManipulateButtons, 'dialog', $author$project$DialogGameEditor$DialogsManipulation, i)
				]));
	});
var $author$project$DialogGameEditor$EditProcDefinition = function (a) {
	return {$: 'EditProcDefinition', a: a};
};
var $author$project$DialogGameEditor$EditProcName = function (a) {
	return {$: 'EditProcName', a: a};
};
var $author$project$DialogGameEditor$ProcedureEdit = function (a) {
	return {$: 'ProcedureEdit', a: a};
};
var $author$project$DialogGameEditor$ProcedureManipulation = function (a) {
	return {$: 'ProcedureManipulation', a: a};
};
var $author$project$DialogGameEditor$SaveProcedure = {$: 'SaveProcedure'};
var $author$project$DialogGameEditor$StartProcedureEdit = function (a) {
	return {$: 'StartProcedureEdit', a: a};
};
var $elm$html$Html$code = _VirtualDom_node('code');
var $author$project$DialogGameEditor$viewProcedure = F3(
	function (model, i, _v0) {
		var name = _v0.a;
		var definition = _v0.b;
		var isEdited = _Utils_eq(
			A2($arturopala$elm_monocle$Monocle$Compose$optionalWithLens, $author$project$Shared$lens_oldValue, $author$project$DialogGameEditor$model_editedProcedure).getOption(model),
			$elm$core$Maybe$Just(
				_Utils_Tuple2(name, definition)));
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			function () {
				var _v1 = _Utils_Tuple2(
					$author$project$DialogGameEditor$model_editedProcedure.getOption(model),
					isEdited);
				if ((_v1.a.$ === 'Just') && _v1.b) {
					var eP = _v1.a.a;
					return _List_fromArray(
						[
							A2(
							$elm$html$Html$input,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$value(eP.name),
									$elm$html$Html$Events$onInput(
									A2($elm$core$Basics$composeR, $author$project$DialogGameEditor$EditProcName, $author$project$DialogGameEditor$ProcedureEdit))
								]),
							_List_Nil),
							A2(
							$elm$html$Html$map,
							A2($elm$core$Basics$composeR, $author$project$DialogGameEditor$EditProcDefinition, $author$project$DialogGameEditor$ProcedureEdit),
							$author$project$ParsedEditable$view(eP.definition)),
							A2(
							$elm$html$Html$button,
							_List_fromArray(
								[
									$elm$html$Html$Events$onClick($author$project$DialogGameEditor$SaveProcedure)
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Save Procedure')
								]))
						]);
				} else {
					return _List_fromArray(
						[
							A2(
							$elm$html$Html$div,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									$elm$html$Html$span,
									_List_Nil,
									_List_fromArray(
										[
											$elm$html$Html$text(name)
										])),
									A2(
									$elm$html$Html$code,
									_List_Nil,
									_List_fromArray(
										[
											$elm$html$Html$text(
											$author$project$ScreeptV2$stringifyStatement(definition))
										])),
									A3($author$project$Shared$viewManipulateButtons, 'procedure', $author$project$DialogGameEditor$ProcedureManipulation, i),
									A2(
									$elm$html$Html$button,
									_List_fromArray(
										[
											$elm$html$Html$Events$onClick(
											$author$project$DialogGameEditor$StartProcedureEdit(
												_Utils_Tuple2(name, definition)))
										]),
									_List_fromArray(
										[
											$elm$html$Html$text('EDIT')
										]))
								]))
						]);
				}
			}());
	});
var $author$project$DialogGameEditor$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h5,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Dialog Editor')
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Title: '),
						A2(
						$elm$html$Html$input,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$value(
								$author$project$DialogGameEditor$model_title.get(model)),
								$elm$html$Html$Attributes$class('focus:ring-2 focus:ring-blue-500 focus:outline-none appearance-none w-full text-sm leading-6 text-slate-900 placeholder-slate-400 rounded-md py-2 pl-10 ring-1 ring-slate-200 shadow-sm'),
								$elm$html$Html$Events$onInput($author$project$DialogGameEditor$EditTitle)
							]),
						_List_Nil)
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('StartDialogId: '),
						A2(
						$elm$html$Html$select,
						_List_fromArray(
							[
								$elm$html$Html$Events$onInput($author$project$DialogGameEditor$EditStartDialogId)
							]),
						A2(
							$elm$core$List$map,
							function (o) {
								return A2(
									$elm$html$Html$option,
									_List_fromArray(
										[
											$elm$html$Html$Attributes$value(o),
											$elm$html$Html$Attributes$selected(
											_Utils_eq(
												o,
												$author$project$DialogGameEditor$model_startDialogId.get(model)))
										]),
									_List_fromArray(
										[
											$elm$html$Html$text(o)
										]));
							},
							$author$project$DialogGameEditor$getDialogIds(model)))
					])),
				A2(
				$elm$html$Html$h6,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Procedures:')
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				A2(
					$elm$core$List$indexedMap,
					$author$project$DialogGameEditor$viewProcedure(model),
					model.gameDefinition.procedures)),
				A2(
				$elm$html$Html$h6,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Dialogs:')
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				A2(
					$elm$core$List$indexedMap,
					$author$project$DialogGameEditor$viewDialog(model),
					model.gameDefinition.dialogs)),
				A2(
				$elm$html$Html$textarea,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$value(
						$author$project$DialogGame$stringifyGameDefinition(model.gameDefinition))
					]),
				_List_Nil)
			]));
};
var $author$project$ScreeptEditor$StatementEditor = function (a) {
	return {$: 'StatementEditor', a: a};
};
var $elm$html$Html$pre = _VirtualDom_node('pre');
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $author$project$ScreeptEditor$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$map,
				$author$project$ScreeptEditor$StatementEditor,
				$author$project$ParsedEditable$view(model.statementEditor)),
				function () {
				var _v0 = model.statementEditor._new;
				if (_v0.$ === 'Ok') {
					var v = _v0.a;
					return A2(
						$elm$html$Html$div,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								$elm$html$Html$pre,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text(
										A2($author$project$ScreeptV2$stringifyPrettyStatement, 0, v))
									])),
								A2(
								$elm$html$Html$pre,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text(
										A3(
											$elm$core$String$replace,
											'\n',
											' ',
											A3(
												$elm$core$String$replace,
												'\"',
												'\\\"',
												$author$project$ScreeptV2$stringifyStatement(v))))
									]))
							]));
				} else {
					return $elm$html$Html$text('');
				}
			}()
			]));
};
var $author$project$Main$ClickUrlLoader = {$: 'ClickUrlLoader'};
var $author$project$Main$EditUrlLoader = function (a) {
	return {$: 'EditUrlLoader', a: a};
};
var $author$project$Main$HideUrlLoader = {$: 'HideUrlLoader'};
var $author$project$Main$viewUrlLoader = function (model) {
	var _v0 = model.urlLoader;
	if (_v0.$ === 'Just') {
		var urlLoader = _v0.a;
		return A2(
			$elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$html$Html$input,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$value(urlLoader),
							$elm$html$Html$Events$onInput($author$project$Main$EditUrlLoader)
						]),
					_List_Nil),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick($author$project$Main$ClickUrlLoader)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Load')
						])),
					A2(
					$elm$html$Html$button,
					_List_fromArray(
						[
							$elm$html$Html$Events$onClick($author$project$Main$HideUrlLoader)
						]),
					_List_fromArray(
						[
							$elm$html$Html$text('Cancel')
						]))
				]));
	} else {
		return $elm$html$Html$text('');
	}
};
var $author$project$Main$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('container')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$button,
				_List_fromArray(
					[
						$elm$html$Html$Events$onClick($author$project$Main$SaveGameDefinition)
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('Save to Localstorage')
					])),
				A2(
				$elm$html$Html$map,
				$author$project$Main$DialogEditor,
				A2(
					$elm$core$Maybe$withDefault,
					$elm$html$Html$text(''),
					A2($elm$core$Maybe$map, $author$project$DialogGameEditor$view, model.dialogEditor))),
				A2(
				$elm$html$Html$map,
				$author$project$Main$MainMenuDialog,
				$author$project$DialogGame$view(model.mainMenuDialog)),
				function () {
				var _v0 = model.gameDialog;
				switch (_v0.$) {
					case 'Started':
						var gameDialogMenu = _v0.b;
						return A2(
							$elm$html$Html$map,
							$author$project$Main$GameDialog,
							$author$project$DialogGame$view(gameDialogMenu));
					case 'NotLoaded':
						return A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('dialog')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('No game definition loaded.')
								]));
					case 'Loading':
						return $elm$html$Html$text('Loading...');
					default:
						var m = _v0.a;
						return A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class('dialog')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text('Loaded game:  ' + (m.title + '.'))
								]));
				}
			}(),
				A2(
				$elm$html$Html$map,
				$author$project$Main$ScreeptEditor,
				$author$project$ScreeptEditor$view(model.screeptEditor)),
				$author$project$Main$viewUrlLoader(model)
			]));
};
var $author$project$Main$main = function () {
	var _v0 = A2(
		$elm$core$Debug$log,
		'Stat Exec ',
		function (e) {
			if (e.$ === 'Err') {
				return $elm$core$Result$Err($author$project$ScreeptV2$UnimplementedYet);
			} else {
				var v = e.a;
				return A2(
					$author$project$ScreeptV2$executeStatement,
					v,
					_Utils_Tuple2($author$project$ScreeptV2$exampleScreeptState, _List_Nil));
			}
		}($author$project$ScreeptV2$parseStatementExample));
	var _v2 = A2($elm$core$Debug$log, 'STAT', $author$project$ScreeptV2$runExample);
	var _v3 = A2($elm$core$Debug$log, 'Statement Parse', $author$project$ScreeptV2$parseStatementExample);
	var _v4 = A2($elm$core$Debug$log, 'S2 Parse', $author$project$ScreeptV2$newScreeptParseExample);
	var _v5 = A2(
		$elm$core$Debug$log,
		'S2 Eval ',
		function (e) {
			if (e.$ === 'Err') {
				return $elm$core$Result$Err($author$project$ScreeptV2$UnimplementedYet);
			} else {
				var v = e.a;
				return A2($author$project$ScreeptV2$evaluateExpression, $author$project$ScreeptV2$exampleScreeptState, v);
			}
		}($author$project$ScreeptV2$newScreeptParseExample));
	return $elm$browser$Browser$element(
		{init: $author$project$Main$init, subscriptions: $author$project$Main$subscriptions, update: $author$project$Main$update, view: $author$project$Main$view});
}();
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));