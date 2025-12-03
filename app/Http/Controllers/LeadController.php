<?php

namespace App\Http\Controllers;

use App\Models\Lead;
use Illuminate\Http\Request;

class LeadController extends Controller
{
    /**
     * Store a newly created lead via API.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getLeads(Request $request)
    {
        $perPage = $request->get('per_page', 100); // /v1/leads?per_page=20
        $leads = Lead::orderBy('created_at', 'desc')->paginate($perPage);
        // $leads = Lead::orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $leads->items(),
            'meta' => [
                'current_page' => $leads->currentPage(),
                'last_page' => $leads->lastPage(),
                'per_page' => $leads->perPage(),
                'total' => $leads->total()
            ]
            ]);
    }

    public function addLead(Request $request)
    {
        $data = $request->validate([
            'name' => 'nullable|string|max:255',
            'tel' => 'nullable|string|max:255',
            'email' => 'nullable|string|max:255',
            'source' => 'nullable|string|max:255',
            'address' => 'nullable|string|max:255',
        ]);

        $lead = Lead::create($data);

        return response()->json([
            'success' => true,
            'data'    => $lead,
            'message' => 'Lead created successfully.',
        ], 201);
    }
    //
}
