"""
AI-Powered Lease Analysis Engine
=================================
LeaseClear-quality analysis using GPT-4
Comprehensive clause extraction with references

Based on BlocIQ v2 LeaseAnalysisEngine
"""

import os
import json
import re
from typing import Dict, List, Optional
from openai import OpenAI


class AILeaseAnalyzer:
    """
    AI-powered lease analysis using GPT-4
    
    Features:
    - Comprehensive LeaseClear-style analysis
    - Quick Q&A (30 seconds)
    - Detailed clause references
    - UK legal terminology
    - Fallback to basic parsing
    """
    
    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize AI lease analyzer
        
        Args:
            api_key: OpenAI API key (or uses OPENAI_API_KEY env var)
        """
        self.api_key = api_key or os.getenv('OPENAI_API_KEY')
        
        if not self.api_key:
            raise ValueError("OpenAI API key required. Set OPENAI_API_KEY environment variable.")
        
        self.client = OpenAI(api_key=self.api_key)
    
    def quick_analysis(
        self, 
        lease_text: str, 
        question: str, 
        filename: str
    ) -> Dict[str, str]:
        """
        Quick lease analysis (30 seconds)
        Perfect for chat interfaces and immediate answers
        
        Args:
            lease_text: Extracted lease text
            question: User's question (e.g., "Are pets allowed?")
            filename: Lease filename
        
        Returns:
            {
                'analysis': 'According to Clause 3(15)...',
                'source': 'ai_quick'
            }
        """
        # Use first 8,000 characters
        truncated_text = lease_text[:8000]
        
        system_prompt = """You are a lease document expert specializing in UK property law.

Provide a focused, practical answer to the user's question about this lease document.

Guidelines:
- Be specific and reference clause numbers where possible
- Use plain English - avoid excessive legal jargon
- Highlight important implications for the leaseholder
- If the document doesn't contain the answer, say so clearly"""

        user_prompt = f"""User Question: "{question}"

Lease Document Text:
{truncated_text}

Provide a focused answer to their question."""

        try:
            response = self.client.chat.completions.create(
                model='gpt-4o-mini',
                messages=[
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': user_prompt}
                ],
                temperature=0.3,
                max_tokens=1500,
                timeout=30
            )
            
            analysis = response.choices[0].message.content or 'Analysis unavailable'
            
            return {
                'analysis': analysis,
                'source': 'ai_quick'
            }
        
        except Exception as e:
            print(f"   ⚠️  Quick analysis failed: {e}")
            return {
                'analysis': 'AI analysis temporarily unavailable. Please try again or review the lease document manually.',
                'source': 'error'
            }
    
    def comprehensive_analysis(
        self,
        lease_text: str,
        filename: str
    ) -> Dict:
        """
        Comprehensive LeaseClear-style analysis (5-10 minutes)
        Full detailed document summary with ALL sections
        
        Args:
            lease_text: Complete lease text
            filename: Lease filename
        
        Returns:
            {
                'doc_type': 'lease',
                'executive_summary': '...',
                'basic_property_details': {...},
                'detailed_sections': [...],
                'other_provisions': [...],
                'disclaimer': '...'
            }
        """
        # Use first 60,000 characters for comprehensive analysis
        truncated_text = lease_text[:60000]
        
        system_prompt = """You are a professional lease analysis service like LeaseClear, specializing in comprehensive UK lease document analysis.

Your task is to extract EVERY detail with the same thoroughness as a professional lease summary service.

Create detailed sections for ALL aspects:
- Basic property details
- Ground rent provisions
- Pet policies
- Alteration & improvement restrictions
- Repair and maintenance responsibilities
- Service charge provisions
- Demised premises definition
- Access rights and easements
- Use restrictions
- Subletting and assignment rules
- Nuisance and annoyance clauses
- Insurance obligations
- Forfeiture and remedial powers
- Company membership requirements

Include specific clause references (e.g., 'Clause 3(15)', 'Schedule 2', 'Page 8').

Return ONLY valid JSON in this exact format:
{
  "doc_type": "lease",
  "executive_summary": "This is a lease for...",
  "basic_property_details": {
    "property_description": "...",
    "lease_term": "...",
    "parties": ["Lessor: ...", "Lessee: ...", "Management Company: ..."],
    "title_number": "...",
    "referenced_clauses": ["Page X", "Clause Y"]
  },
  "detailed_sections": [
    {
      "section_title": "Ground Rent",
      "content": ["The ground rent is..."],
      "referenced_clauses": ["Clause 2(1)"]
    }
  ],
  "other_provisions": [
    {
      "title": "...",
      "description": "...",
      "referenced_clauses": ["..."]
    }
  ],
  "disclaimer": "This analysis is for informational purposes only..."
}"""

        user_prompt = f"""Analyze this UK lease document comprehensively:

Filename: {filename}

Lease Text:
{truncated_text}

Provide a complete analysis with ALL sections and clause references."""

        try:
            print(f"   🤖 Running AI analysis on {filename}...")
            print(f"   ⏱️  This will take 5-10 minutes (GPT-4 comprehensive analysis)...")
            
            response = self.client.chat.completions.create(
                model='gpt-4o',
                messages=[
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': user_prompt}
                ],
                temperature=0.1,
                max_tokens=6000,
                response_format={'type': 'json_object'}
            )
            
            analysis_text = response.choices[0].message.content or '{}'
            
            # Parse JSON response
            summary = self._parse_analysis_json(analysis_text, filename, len(lease_text))
            
            print(f"   ✅ AI analysis complete!")
            
            return summary
        
        except Exception as e:
            print(f"   ⚠️  Comprehensive analysis failed: {e}")
            print(f"   🔄 Falling back to basic extraction...")
            
            return self._create_fallback_summary(filename, len(lease_text))
    
    def _parse_analysis_json(
        self,
        analysis_text: str,
        filename: str,
        text_length: int
    ) -> Dict:
        """Parse AI JSON response with robust error handling"""
        try:
            # Clean markdown code blocks
            cleaned_text = analysis_text.strip()
            cleaned_text = re.sub(r'^```json\s*', '', cleaned_text)
            cleaned_text = re.sub(r'\s*```$', '', cleaned_text)
            
            summary = json.loads(cleaned_text)
            
            # Validate required fields
            if not summary.get('doc_type') or not summary.get('executive_summary'):
                raise ValueError('Missing required fields')
            
            return summary
        
        except Exception as e:
            print(f"   ⚠️  JSON parsing failed: {e}")
            return self._create_fallback_summary(filename, text_length)
    
    def _create_fallback_summary(
        self,
        filename: str,
        text_length: int
    ) -> Dict:
        """Create fallback summary when AI parsing fails"""
        return {
            'doc_type': 'lease',
            'executive_summary': f'Analysis of {filename} completed with {text_length} characters extracted. AI parsing encountered issues - manual review recommended.',
            'basic_property_details': {
                'property_description': 'Property details present - manual review recommended',
                'lease_term': 'Lease terms detected - detailed extraction needed',
                'parties': ['Parties identified', 'Manual review recommended'],
                'referenced_clauses': []
            },
            'detailed_sections': [
                {
                    'section_title': 'Processing Status',
                    'content': [
                        '✅ Document uploaded successfully',
                        '✅ OCR text extraction completed',
                        '⚠️ AI parsing failed - manual review needed',
                        '💡 The document contains lease-related content but requires professional review for detailed analysis'
                    ],
                    'referenced_clauses': []
                }
            ],
            'other_provisions': [
                {
                    'title': 'Next Steps',
                    'description': 'Please review the extracted text manually or contact support for assistance with this document.',
                    'referenced_clauses': []
                }
            ],
            'disclaimer': 'Parsing issues encountered. Manual review required for accurate lease analysis.'
        }
    
    def analyze_lease(
        self,
        lease_text: str,
        filename: str,
        mode: str = 'comprehensive'
    ) -> Dict:
        """
        Main entry point for lease analysis
        
        Args:
            lease_text: Complete lease text
            filename: Lease filename
            mode: 'quick' or 'comprehensive'
        
        Returns:
            Complete lease analysis
        """
        if mode == 'quick':
            # For quick mode, need a question - return comprehensive instead
            return self.comprehensive_analysis(lease_text, filename)
        
        return self.comprehensive_analysis(lease_text, filename)


def format_analysis_for_pdf(analysis: Dict) -> str:
    """
    Format comprehensive analysis for PDF display
    Returns markdown/text suitable for PDF generation
    """
    lines = []
    
    # Title
    prop_desc = analysis.get('basic_property_details', {}).get('property_description', 'Lease Analysis')
    lines.append(f"# {prop_desc}")
    lines.append("")
    
    # Executive Summary
    lines.append("## Executive Summary")
    lines.append(analysis.get('executive_summary', 'N/A'))
    lines.append("")
    
    # Basic Details
    lines.append("## Basic Property Details")
    lines.append("")
    basic = analysis.get('basic_property_details', {})
    lines.append(f"**Lease Term:** {basic.get('lease_term', 'N/A')}")
    lines.append("")
    lines.append("**Parties:**")
    for party in basic.get('parties', []):
        lines.append(f"- {party}")
    
    if basic.get('title_number'):
        lines.append(f"\n**Title Number:** {basic['title_number']}")
    lines.append("")
    
    # Detailed Sections
    lines.append("## Detailed Analysis")
    lines.append("")
    
    for section in analysis.get('detailed_sections', []):
        lines.append(f"### {section['section_title']}")
        lines.append("")
        
        for item in section.get('content', []):
            lines.append(item)
            lines.append("")
        
        if section.get('referenced_clauses'):
            refs = ', '.join(section['referenced_clauses'])
            lines.append(f"*References: {refs}*")
            lines.append("")
    
    # Other Provisions
    other = analysis.get('other_provisions', [])
    if other:
        lines.append("## Other Provisions")
        lines.append("")
        
        for provision in other:
            lines.append(f"**{provision['title']}:** {provision['description']}")
            if provision.get('referenced_clauses'):
                refs = ', '.join(provision['referenced_clauses'])
                lines.append(f"*References: {refs}*")
            lines.append("")
    
    # Disclaimer
    lines.append("---")
    lines.append("")
    lines.append(f"*{analysis.get('disclaimer', 'This analysis is for informational purposes only.')}*")
    
    return '\n'.join(lines)

