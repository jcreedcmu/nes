#ifndef _REG_EX_H_
#define _REG_EX_H_

//#define REGEX_DEBUG

class RegEx
{
	public:
		RegEx();
		~RegEx();
		void Load(const char*);
		int Matches(const char*); //-1 if no match, else num matching chars
	private:
		bool SetContains(const char*, char);
		int WhereInSet(const char*, char);
		char ParseChar(const char*, int&);
		bool plainstring; //false==set
		bool repeat; //false==once, true==any number
		char* value; //string or set
		int valuelen;
		RegEx *next;
};

#endif
