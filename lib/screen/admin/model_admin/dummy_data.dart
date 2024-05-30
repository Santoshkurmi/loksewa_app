List<Map<String, dynamic>> types = [
  {"id": 1, "title": "GK(General Knowledge)", "image": "", "type": "gk"},
  {"id": 2, "title": "IQ (Intelligent Quotient)", "image": "", "type": "iq"},
  {"id": 1, "title": "Technical English", "image": "", "type": "tech_english"},
];


Map<String,dynamic> questionsDummpy = {
  "gk_01":[
      {
        "id":1,
        "title":"What is the capital city of Nepal",
        "topicId":1,
        "optionA":"Kathmandu",
        "optionB":"China",
        "optionC":"London",
        "optionD":"Korea",
        "correctAns":"A"
      },
      {
        "id":2,
        "title":"What is the capital city of China",
        "topicId":1,
        "optionA":"Kathmandu",
        "optionB":"Beijing",
        "optionC":"London",
        "optionD":"Korea",
        "correctAns":"B"
      },
  ]//questions
};


 Map<String, List<Map<String,dynamic>> > categories = {
  "gk": [
    {
      "id": 1,
      "title": "Nepal bhugol",
      "path": "gk_01",
      "subCategories": [
        {
          "id": 1,
          "title": "Mountain",
        },
        {
          "id": 2,
          "title": "Terai",
        },
      ]
    }
  ],//gk
  "iq": [
    {
      "id": 1,
      "title": "Attention",
      "path": "iq_01",
      "subCategories": [
        {
          "id": 1,
          "title": "Tricky",
        },
        {
          "id": 2,
          "title": "Mind games",
        },
      ]
    }
  ],//iq
};
