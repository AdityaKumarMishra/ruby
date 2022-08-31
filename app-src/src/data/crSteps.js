export const steps = [
  {
    id: 1,
    type: 'inline-block',
    question: 'What are you currently studying for?',
    answers: [
      {
        value: 'GAMSAT'
      },
      {
        value: 'UCAT'
      }
    ]
  },
  {
    id: 2,
    type: 'block',
    question: 'In which area are you wishing to improve?',
    answersA: [
      {
        value: 'Mathematics Extension 1'
      },
      {
        value: 'English Advanced'
      }
    ],
    answersB: [
      {
        value: 'English'
      },
      {
        value: 'Mathematical Method'
      }
    ]
  },
  {
    id: 3,
    type: 'radio',
    question: 'Do you have a science background?',
    answers: [
      {
        value: 'Yes',
         weights: {
           'OE': 2,
           'OC': 2,
           'AE': 1
         }
      },
      {
        value: 'No',
         weights: {
           'ACT': 3,
           'AC': 2,
           'AE': 1,
           'OC': 1
         }
      }
    ]
  },
  {
    id: 4,
    type: 'radio',
    question: 'How much help do you need to reach your goals?',
    answers: [
      {
        value: 'A lot of help',
         weights: {
           'ACT': 3,
           'AC': 2,
           'AE': 1
         }
      },
      {
         value: 'Some guidance',
         weights: {
           'OC': 2,
           'AE': 2,
           'AC': 1
         }
      },
      {
         value: 'Just after some self learning and practice',
         weights: {
           'OE': 3,
           'AE': 1
         }
      }
    ]
  },
  {
    id: 5,
    type: 'radio',
    question: 'How much time per week can you commit to studying?',
    answers: [
      {
        value: 'Less than 5 hours',
         weights: {
           'OC': 2,
           'OE': 2
         }
      },
      {
        value: 'Between 5 and 10 hours',
         weights: {
           'AE': 2,
           'OC': 1,
           'AC': 1
         }
      },
      {
         value: 'More than 10 hours',
         weights: {
           'ACT': 3,
           'AC': 2,
           'AE': 2
         }
      }
    ]
  },
  {
    id: 6,
    type: 'radio',
    question: 'How do you best learn?',
    answers: [
      {
         value: 'On my own',
         weigts: {
           'OE': 1,
           'OC': 1
         }
      },
      {
        value: 'Face to face',
         weights: {
           'ACT': 1,
           'AC': 1,
           'AE': 1,
           'OE': -1,
           'OC': -1
         }
      },
      {
        value: 'One on one',
         weights: {
           'ACT': 1,
           'C': 5,
           'OE': -1,
           'OC': -1
         }
      }
    ]
  },
  {
    id: 7,
    type: 'radio',
    question: 'Do you find you struggle in exam situations?',
    answers: [
      {
        value: 'Yes',
         weights: {
           'OC': 1,
           'AC': 1,
           'ACT': 1,
           'C': 1
         }
      },
      {
         value: 'Not really',
         weights: {
           'OE': 2,
           'AE': 1
         }
      }
    ]
  },
  {
    id: 8,
    type: 'radio',
    question: 'Do you struggle with essay writing?',
    answers: [
      {
        value: 'Yes',
         weights: {
           'OC': 1,
           'C': 2,
           'AC': 1,
           'ACT': 1
         }
      },
      {
         value: 'No',
         weights: {
           'OE': 1,
           'AE': 1
         }
      }
    ]
  },
  {
    id: 9,
    type: 'radio',
     question: 'How much money are you prepared to spend on your preparation?',
    answers: [
      {
        value: 'Cheapest option',
         weights: {
           'C': 4,
           'OE': 1,
           'AC': -3
         }
      },
      {
        value: 'A moderate amount',
         weights: {
           'OC': 1,
           'AE': 1
         }
      },
      {
         value: 'Quality is the ONLY thing that matters',
         weights: {
           'ACT': 1,
           'AC': 1
         }
      }
    ]
  }
]
