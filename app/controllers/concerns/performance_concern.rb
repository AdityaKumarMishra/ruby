module PerformanceConcern
extend ActiveSupport::Concern

	def get_avg_performance(tag, avg_performance, type)
		emails = ["benn.oc.roberts@gmail.com","laurenwijaya01@gmail.com", "mollyjobristow@gmail.com", "tomjpmcspam@gmail.com"]

		if emails.include? current_user.email
			if type == 'exam'
				static_avg_performance =  stat_json[:"#{current_user.email.split('@').first}"][:"#{tag.name.strip}"]
			elsif type == 'mcq'
				static_avg_performance =  stat_mcq_json[:"#{tag.name.strip}"]
			end
		end
		return static_avg_performance.to_f || avg_performance
	end

	def stat_json
		{
		    "benn.oc.roberts": {
		    		"GM.01.00 General": "0",
		        
		            "GM.01.01 Poetry": "49.16",
		        
		            "GM.01.02 Fiction": "48.45",
		        
		            "GM.01.03 Cartoon and comics": "48.28",
		        
		            "GM.01.04 Non-fiction": "55.7",
		        
		            "GM.01.05 Charts and diagrams": "63.57",
		        
		            "GM.01.05 Non-fiction non-medical": "52.46",
		        
		            "GM.01 Humanities": "52.8",
		        
		            "GM.02.01 Biomolecules & the cell": "60.8",
		        
		            "GM.02.02 Enzymes, cellular metabolism & the central dogma": "62.1",
		        
		            "GM.02.03 Cell division": "59.4",
		        
		            "GM.02.04 Nervous system": "57.4",
		        
		            "GM.02.05 Musculoskeletal system": "54.5",
		        
		            "GM.02.06 Cardiovascular system": "60.4",
		        
		            "GM.02.07 Respiratory system": "54.1",
		        
		            "GM.02.08 Gastrointestinal system": "59.4",
		        
		            "GM.02.09 Renal system": "54.8",
		        
		            "GM.02.10 Endocrine system": "51.7",
		        
		            "GM.02.11 Immune system": "55.4",
		        
		            "GM.02.12 Genetics & Evolution": "62.1",
		        
		            "GM.02.13 Reproductive system": "55.4",
		        
		            "GM.02.14 Experimental design and data analysis": "60.9",
		        
		            "GM.02 Biology": "57.74",
		        
		            "GM.03.00 Chemistry Preamble": "0",
		        
		            "GM.03.01 The Atom": "61.2",
		        
		            "GM.03.02 Chemical Equations and Stoichiometry": "55.4",
		        
		            "GM.03.03 Electrons and Chemical Bonds": "59.7",
		        
		            "GM.03.04 Gases": "55.3",
		        
		            "GM.03.05 Thermodynamics and kinetics": "53.4",
		        
		            "GM.03.06 Acids, Bases, Buffers and Redox reactions": "56.1",
		        
		            "GM.03.07 Electrochemistry": "60.9",
		        
		            "GM.03.08 Common organic reactions": "51.4",
		        
		            "GM.03.09 Special organic reactions": "49.7",
		        
		            "GM.03.10 Stereochemistry and projections": "51.3",
		        
		            "GM.03.11 Biochemistry": "58.6",
		        
		            "GM.03.12 Spectroscopies and Spectrometries": "55.6",
		        
		            "GM.03.13 Laboratory Techniques": "56.1",
		        
		            "GM.03 Chemistry": "55.7",
		        
		            "GM.04.00 General": "0",
		        
		            "GM.04.01 Linear Motion": "58.7",
		        
		            "GM.04.02 Motion in 2 Dimensions": "55.4",
		        
		            "GM.04.03 Newton's Laws and Types of Forces": "53.9",
		        
		            "GM.04.04 Mechanical Equilibrium": "51.4",
		        
		            "GM.04.05 Work, Energy and Momentum": "50.2",
		        
		            "GM.04.06 Fluids, Pressure and Heat": "49.6",
		        
		            "GM.04.07 Electromagnetism": "59.2",
		        
		            "GM.04.08 Electrical Circuits": "60.3",
		        
		            "GM.04.09 Waves and Optics": "50.7",
		        
		            "GM.04.10 Nuclear Physics": "55.7",
		        
		            "GM.04 Physics": "54.5"
		        },
		    
		    "laurenwijaya01": {
		        
		            "GM.01.00 General": "0",
		        
		            "GM.01.01 Poetry": "49.11",
		        
		            "GM.01.02 Fiction": "48.56",
		        
		            "GM.01.03 Cartoon and comics": "48.39",
		        
		            "GM.01.04 Non-fiction": "55.83",
		        
		            "GM.01.05 Charts and diagrams": "63.48",
		        
		            "GM.01.05 Non-fiction non-medical": "52.4",
		        
		            "GM.01 Humanities": "52.82",
		        
		            "GM.02.01 Biomolecules & the cell": "62.1",
		        
		            "GM.02.02 Enzymes, cellular metabolism & the central dogma": "60.8",
		        
		            "GM.02.03 Cell division": "57.4",
		        
		            "GM.02.04 Nervous system": "59.4",
		        
		            "GM.02.05 Musculoskeletal system": "57.8",
		        
		            "GM.02.06 Cardiovascular system": "61.2",
		        
		            "GM.02.07 Respiratory system": "56.7",
		        
		            "GM.02.08 Gastrointestinal system": "60.2",
		        
		            "GM.02.09 Renal system": "54.1",
		        
		            "GM.02.10 Endocrine system": "52.2",
		        
		            "GM.02.11 Immune system": "54",
		        
		            "GM.02.12 Genetics & Evolution": "60.8",
		        
		            "GM.02.13 Reproductive system": "56.1",
		        
		            "GM.02.14 Experimental design and data analysis": "58.7",
		        
		            "GM.02 Biology": "57.96",
		        
		            "GM.03.00 Chemistry Preamble": "0",
		        
		            "GM.03.01 The Atom": "60.7",
		        
		            "GM.03.02 Chemical Equations and Stoichiometry": "60.3",
		        
		            "GM.03.03 Electrons and Chemical Bonds": "58.4",
		        
		            "GM.03.04 Gases": "57.1",
		        
		            "GM.03.05 Thermodynamics and kinetics": "52.9",
		        
		            "GM.03.06 Acids, Bases, Buffers and Redox reactions": "56.8",
		        
		            "GM.03.07 Electrochemistry": "59.3",
		        
		            "GM.03.08 Common organic reactions": "51.1",
		        
		            "GM.03.09 Special organic reactions": "49.6",
		        
		            "GM.03.10 Stereochemistry and projections": "52.5",
		        
		            "GM.03.11 Biochemistry": "56.4",
		        
		            "GM.03.12 Spectroscopies and Spectrometries": "57.7",
		        
		            "GM.03.13 Laboratory Techniques": "58.2",
		        
		            "GM.03 Chemistry": "56.2",
		        
		            "GM.04.00 General": "0",
		        
		            "GM.04.01 Linear Motion": "60.2",
		        
		            "GM.04.02 Motion in 2 Dimensions": "54.2",
		        
		            "GM.04.03 Newton's Laws and Types of Forces": "53.8",
		        
		            "GM.04.04 Mechanical Equilibrium": "51.3",
		        
		            "GM.04.05 Work, Energy and Momentum": "50.6",
		        
		            "GM.04.06 Fluids, Pressure and Heat": "49.9",
		        
		            "GM.04.07 Electromagnetism": "57.3",
		        
		            "GM.04.08 Electrical Circuits": "58.9",
		        
		            "GM.04.09 Waves and Optics": "51.2",
		        
		            "GM.04.10 Nuclear Physics": "54.8",
		        
		            "GM.04 Physics": "54.2"
		        },
		    "mollyjobristow": {
		        
		            "GM.01.00 General": "0",
		        
		            "GM.01.01 Poetry": "49.16",
		        
		            "GM.01.02 Fiction": "48.61",
		        
		            "GM.01.03 Cartoon and comics": "48.47",
		        
		            "GM.01.04 Non-fiction": "55.81",
		        
		            "GM.01.05 Charts and diagrams": "63.52",
		        
		            "GM.01.05 Non-fiction non-medical": "52.4",
		        
		            "GM.01 Humanities": "52.85",
		        
		            "GM.02.01 Biomolecules & the cell": "61.2",
		        
		            "GM.02.02 Enzymes, cellular metabolism & the central dogma": "61.7",
		        
		            "GM.02.03 Cell division": "58.5",
		        
		            "GM.02.04 Nervous system": "58.3",
		        
		            "GM.02.05 Musculoskeletal system": "59.6",
		        
		            "GM.02.06 Cardiovascular system": "61.5",
		        
		            "GM.02.07 Respiratory system": "58.84",
		        
		            "GM.02.08 Gastrointestinal system": "56.4",
		        
		            "GM.02.09 Renal system": "55",
		        
		            "GM.02.10 Endocrine system": "53",
		        
		            "GM.02.11 Immune system": "54.2",
		        
		            "GM.02.12 Genetics & Evolution": "60.3",
		        
		            "GM.02.13 Reproductive system": "55.4",
		        
		            "GM.02.14 Experimental design and data analysis": "59.1",
		        
		            "GM.02 Biology": "58.1",
		        
		            "GM.03.00 Chemistry Preamble": "0",
		        
		            "GM.03.01 The Atom": "61.2",
		        
		            "GM.03.02 Chemical Equations and Stoichiometry": "59.8",
		        
		            "GM.03.03 Electrons and Chemical Bonds": "59.5",
		        
		            "GM.03.04 Gases": "57",
		        
		            "GM.03.05 Thermodynamics and kinetics": "51.6",
		        
		            "GM.03.06 Acids, Bases, Buffers and Redox reactions": "57.4",
		        
		            "GM.03.07 Electrochemistry": "58.2",
		        
		            "GM.03.08 Common organic reactions": "51.6",
		        
		            "GM.03.09 Special organic reactions": "49.7",
		        
		            "GM.03.10 Stereochemistry and projections": "50.2",
		        
		            "GM.03.11 Biochemistry": "57.4",
		        
		            "GM.03.12 Spectroscopies and Spectrometries": "59.7",
		        
		            "GM.03.13 Laboratory Techniques": "56.4",
		        
		            "GM.03 Chemistry": "56.1",
		        
		            "GM.04.00 General": "0",
		        
		            "GM.04.01 Linear Motion": "61.3",
		        
		            "GM.04.02 Motion in 2 Dimensions": "55.7",
		        
		            "GM.04.03 Newton's Laws and Types of Forces": "51.4",
		        
		            "GM.04.04 Mechanical Equilibrium": "52.9",
		        
		            "GM.04.05 Work, Energy and Momentum": "50.2",
		        
		            "GM.04.06 Fluids, Pressure and Heat": "49.7",
		        
		            "GM.04.07 Electromagnetism": "60.1",
		        
		            "GM.04.08 Electrical Circuits": "55.8",
		        
		            "GM.04.09 Waves and Optics": "50.8",
		        
		            "GM.04.10 Nuclear Physics": "55.7",
		        
		            "GM.04 Physics": "54.36"
		        },
		    
		    "tomjpmcspam": {
		        
		            "GM.01.00 General": "0",
		        
		            "GM.01.01 Poetry": "49.17",
		        
		            "GM.01.02 Fiction": "48.6",
		        
		            "GM.01.03 Cartoon and comics": "48.49",
		        
		            "GM.01.04 Non-fiction": "55.79",
		        
		            "GM.01.05 Charts and diagrams": "63.55",
		        
		            "GM.01.05 Non-fiction non-medical": "52.43",
		        
		            "GM.01 Humanities": "52.85",
		        
		            "GM.02.01 Biomolecules & the cell": "60.4",
		        
		            "GM.02.02 Enzymes, cellular metabolism & the central dogma": "62.3",
		        
		            "GM.02.03 Cell division": "57.8",
		        
		            "GM.02.04 Nervous system": "57.4",
		        
		            "GM.02.05 Musculoskeletal system": "59.8",
		        
		            "GM.02.06 Cardiovascular system": "62.4",
		        
		            "GM.02.07 Respiratory system": "58.88",
		        
		            "GM.02.08 Gastrointestinal system": "56.8",
		        
		            "GM.02.09 Renal system": "54.7",
		        
		            "GM.02.10 Endocrine system": "53.4",
		        
		            "GM.02.11 Immune system": "54",
		        
		            "GM.02.12 Genetics & Evolution": "59.8",
		        
		            "GM.02.13 Reproductive system": "53.8",
		        
		            "GM.02.14 Experimental design and data analysis": "58.7",
		        
		            "GM.02 Biology": "57.87",
		        
		            "GM.03.00 Chemistry Preamble": "0",
		        
		            "GM.03.01 The Atom": "60.9",
		        
		            "GM.03.02 Chemical Equations and Stoichiometry": "60.3",
		        
		            "GM.03.03 Electrons and Chemical Bonds": "58.9",
		        
		            "GM.03.04 Gases": "58.3",
		        
		            "GM.03.05 Thermodynamics and kinetics": "52",
		        
		            "GM.03.06 Acids, Bases, Buffers and Redox reactions": "56.7",
		        
		            "GM.03.07 Electrochemistry": "59.3",
		        
		            "GM.03.08 Common organic reactions": "50.9",
		        
		            "GM.03.09 Special organic reactions": "49.4",
		        
		            "GM.03.10 Stereochemistry and projections": "50.1",
		        
		            "GM.03.11 Biochemistry": "58.5",
		        
		            "GM.03.12 Spectroscopies and Spectrometries": "59",
		        
		            "GM.03.13 Laboratory Techniques": "55",
		        
		            "GM.03 Chemistry": "56.1",
		        
		            "GM.04.00 General": "0",
		        
		            "GM.04.01 Linear Motion": "60.7",
		        
		            "GM.04.02 Motion in 2 Dimensions": "56.5",
		        
		            "GM.04.03 Newton's Laws and Types of Forces": "51",
		        
		            "GM.04.04 Mechanical Equilibrium": "52.3",
		        
		            "GM.04.05 Work, Energy and Momentum": "51.7",
		        
		            "GM.04.06 Fluids, Pressure and Heat": "50.3",
		        
		            "GM.04.07 Electromagnetism": "58.9",
		        
		            "GM.04.08 Electrical Circuits": "55.2",
		        
		            "GM.04.09 Waves and Optics": "50.9",
		        
		            "GM.04.10 Nuclear Physics": "55.9",
		        
		            "GM.04 Physics": "54.34"
		        }
		    
		}
	end

	def stat_mcq_json
		{
        
            "GM.01.00 General": "0",
        
            "GM.01.01 Poetry": "54.2",
        
            "GM.01.02 Fiction": "57.8",
        
            "GM.01.03 Cartoon and comics": "58.1",
        
            "GM.01.04 Non-fiction": "60.1",
        
            "GM.01.05 Charts and diagrams": "64.6",
        
            "GM.01.05 Non-fiction non-medical": "56.4",
        
            "GM.01 Humanities": "58.5",
        
            "GM.02.01 Biomolecules & the cell": "65.2",
        
            "GM.02.02 Enzymes, cellular metabolism & the central dogma": "63.2",
        
            "GM.02.03 Cell division": "64.2",
        
            "GM.02.04 Nervous system": "61.9",
        
            "GM.02.05 Musculoskeletal system": "63.2",
        
            "GM.02.06 Cardiovascular system": "67.5",
        
            "GM.02.07 Respiratory system": "59.4",
        
            "GM.02.08 Gastrointestinal system": "61.4",
        
            "GM.02.09 Renal system": "60",
        
            "GM.02.10 Endocrine system": "58.2",
        
            "GM.02.11 Immune system": "59.2",
        
            "GM.02.12 Genetics & Evolution": "64.4",
        
            "GM.02.13 Reproductive system": "57.4",
        
            "GM.02.14 Experimental design and data analysis": "62.1",
        
            "GM.02 Biology": "61.95",
        
            "GM.03.00 Chemistry Preamble": "0",
        
            "GM.03.01 The Atom": "63.4",
        
            "GM.03.02 Chemical Equations and Stoichiometry": "59.4",
        
            "GM.03.03 Electrons and Chemical Bonds": "58.9",
        
            "GM.03.04 Gases": "59.4",
        
            "GM.03.05 Thermodynamics and kinetics": "56.4",
        
            "GM.03.06 Acids, Bases, Buffers and Redox reactions": "59.4",
        
            "GM.03.07 Electrochemistry": "61.2",
        
            "GM.03.08 Common organic reactions": "56.4",
        
            "GM.03.09 Special organic reactions": "50.2",
        
            "GM.03.10 Stereochemistry and projections": "52.8",
        
            "GM.03.11 Biochemistry": "58.2",
        
            "GM.03.12 Spectroscopies and Spectrometries": "59.9",
        
            "GM.03.13 Laboratory Techniques": "60.5",
        
            "GM.03 Chemistry": "58.2",
        
            "GM.04.00 General": "0",
        
            "GM.04.01 Linear Motion": "61.8",
        
            "GM.04.02 Motion in 2 Dimensions": "57.9",
        
            "GM.04.03 Newton's Laws and Types of Forces": "56.6",
        
            "GM.04.04 Mechanical Equilibrium": "55.7",
        
            "GM.04.05 Work, Energy and Momentum": "53.2",
        
            "GM.04.06 Fluids, Pressure and Heat": "56.9",
        
            "GM.04.07 Electromagnetism": "58.7",
        
            "GM.04.08 Electrical Circuits": "60.1",
        
            "GM.04.09 Waves and Optics": "55.4",
        
            "GM.04.10 Nuclear Physics": "61.5",
        
            "GM.04 Physics": "57.8"
        }
	end
end
